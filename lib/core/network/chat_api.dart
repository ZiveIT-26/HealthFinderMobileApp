import 'dart:convert';

import 'package:http/http.dart' as http;

import 'chat_models.dart';

class ChatApi {
  /// [clientFactory] creates the HTTP client for each call; pass
  /// `authController.createClient` to send the user's token.
  ChatApi(this.baseUrl, {http.Client Function()? clientFactory})
    : _newClient = clientFactory ?? http.Client.new;

  final String baseUrl;
  final http.Client Function() _newClient;

  /// POST /chat -> returns streamId + sessionId
  Future<({String streamId, String sessionId})> startChat(
    String prompt, {
    String? sessionId,
    double? lat,
    double? lon,
  }) async {
    final client = _newClient();
    final http.Response res;
    try {
      res = await client.post(
        Uri.parse('$baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'sessionId': ?sessionId,
          if (lat != null && lon != null) 'location': {'lat': lat, 'lon': lon},
        }),
      );
    } finally {
      client.close();
    }

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

  /// POST /chat/location -> answers a [LocationRequestEvent] of a running
  /// stream. Throws [LocationRequestExpired] when the server no longer waits.
  Future<void> answerLocation(String requestId, LocationAnswer answer) async {
    final body = switch (answer) {
      LocationShared() => {
        'requestId': requestId,
        'source': answer.source.name,
        'location': {
          'lat': answer.latitude,
          'lon': answer.longitude,
          'label': ?answer.area,
        },
      },
      LocationDeclined() => {'requestId': requestId, 'source': 'declined'},
    };

    final client = _newClient();
    final http.Response res;
    try {
      res = await client.post(
        Uri.parse('$baseUrl/chat/location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
    } finally {
      client.close();
    }

    if (res.statusCode == 404) throw const LocationRequestExpired();
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('Location answer failed: ${res.statusCode} ${res.body}');
    }
  }

  /// GET /chat/stream/:id -> Server-Sent Events, turned into a Dart Stream
  Stream<ChatEvent> stream(String streamId) async* {
    final client = _newClient();
    try {
      final req =
          http.Request('GET', Uri.parse('$baseUrl/chat/stream/$streamId'))
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
        final json =
            jsonDecode(line.substring(5).trim()) as Map<String, dynamic>;

        switch (json['type']) {
          case 'heartbeat':
            yield HeartbeatEvent();
          case 'error':
            yield ErrorEvent(json['message'] ?? 'Unknown error');
          case 'location_request':
            yield LocationRequestEvent(
              json['requestId'] as String,
              json['reason'] as String?,
              change: json['change'] == true,
            );
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

  /// GET /chat/sessions -> newest first
  Future<List<ChatSession>> fetchSessions() async {
    final res = await _send((c) => c.get(Uri.parse('$baseUrl/chat/sessions')));
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => ChatSession.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Checks the authenticated, database-backed chat endpoint.
  Future<void> checkAvailability() async {
    final client = _newClient();
    try {
      final res = await client
          .get(Uri.parse('$baseUrl/chat/sessions'))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception(
          'Chat availability check failed: ${res.statusCode} ${res.body}',
        );
      }
    } finally {
      client.close();
    }
  }

  /// GET /chat/history/:sessionId -> chronological
  Future<List<HistoryMessage>> fetchHistory(String sessionId) async {
    final res = await _send(
      (c) => c.get(Uri.parse('$baseUrl/chat/history/$sessionId')),
    );
    final list = jsonDecode(res.body) as List;
    return list
        .map((e) => HistoryMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// PATCH /chat/sessions/:id
  Future<void> renameSession(String sessionId, String title) => _send(
    (c) => c.patch(
      Uri.parse('$baseUrl/chat/sessions/$sessionId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title}),
    ),
  );

  /// DELETE /chat/sessions/:id
  Future<void> deleteSession(String sessionId) =>
      _send((c) => c.delete(Uri.parse('$baseUrl/chat/sessions/$sessionId')));

  /// DELETE /chat/sessions (all sessions of the user)
  Future<void> deleteAllSessions() =>
      _send((c) => c.delete(Uri.parse('$baseUrl/chat/sessions')));

  /// Runs one request with a fresh client; throws on non-2xx.
  Future<http.Response> _send(
    Future<http.Response> Function(http.Client c) call,
  ) async {
    final client = _newClient();
    try {
      final res = await call(client).timeout(const Duration(seconds: 5));
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw Exception('Request failed: ${res.statusCode} ${res.body}');
      }
      return res;
    } finally {
      client.close();
    }
  }
}
