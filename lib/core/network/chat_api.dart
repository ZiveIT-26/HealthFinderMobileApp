import 'dart:convert';
import 'package:http/http.dart' as http;
import 'chat_models.dart';

class ChatApi {
  ChatApi(this.baseUrl);
  final String baseUrl;

  /// POST /chat -> returns streamId + sessionId
  Future<({String streamId, String sessionId})> startChat(
    String prompt, {
    String? sessionId,
    double? lat,
    double? lon,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'prompt': prompt,
        'sessionId': ?sessionId,
        if (lat != null && lon != null) 'location': {'lat': lat, 'lon': lon},
      }),
    );

    // NestJS POST returns 201 by default, so accept any 2xx
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Chat failed: ${res.statusCode} ${res.body}');
    }

    final j = jsonDecode(res.body) as Map<String, dynamic>;
    return (
      streamId: j['streamId'] as String,
      sessionId: j['sessionId'] as String,
    );
  }

  /// GET /chat/stream/:id -> Server-Sent Events, turned into a Dart Stream
  Stream<ChatEvent> stream(String streamId) async* {
    final client = http.Client();
    try {
      final req = http.Request('GET', Uri.parse('$baseUrl/chat/stream/$streamId'))
        ..headers['Accept'] = 'text/event-stream'
        ..headers['Cache-Control'] = 'no-cache';

      final res = await client.send(req);
      if (res.statusCode != 200) {
        throw Exception('Stream failed: ${res.statusCode}');
      }

      // bytes -> text -> one line at a time
      final lines = res.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter());

      await for (final line in lines) {
        if (!line.startsWith('data:')) continue; // skip empty separator lines
        final json = jsonDecode(line.substring(5).trim()) as Map<String, dynamic>;

        switch (json['type']) {
          case 'heartbeat':
            yield HeartbeatEvent();
          case 'error':
            yield ErrorEvent(json['message'] ?? 'Unknown error');
          case 'doctors_list':
            yield DoctorsEvent(
              (json['doctors'] as List)
                  .map((d) => Doctor.fromJson(d as Map<String, dynamic>))
                  .toList(),
            );
          default: // 'token'
            if (json['text'] != null) yield TokenEvent(json['text']);
        }
      }
    } finally {
      client.close(); // closes the connection when done or cancelled
    }
  }
}