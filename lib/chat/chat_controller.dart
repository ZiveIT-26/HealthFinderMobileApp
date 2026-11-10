import 'dart:async';
import 'package:flutter/foundation.dart';
import 'chat_api.dart';
import 'chat_models.dart';

class Message {
  final bool isUser;
  String text;
  List<Doctor> doctors;
  Message({required this.isUser, this.text = '', this.doctors = const []});
}

class ChatController extends ChangeNotifier {
  ChatController(this._api);
  final ChatApi _api;

  final List<Message> messages = [];
  String? _sessionId; // remembered for follow-up messages
  bool loading = false;
  StreamSubscription<ChatEvent>? _sub;

  Future<void> send(String prompt, {double? lat, double? lon}) async {
    await _sub?.cancel();

    messages.add(Message(isUser: true, text: prompt));
    final reply = Message(isUser: false); // filled in as tokens arrive
    messages.add(reply);
    loading = true;
    notifyListeners(); // tells the UI to redraw

    try {
      final start = await _api.startChat(
        prompt,
        sessionId: _sessionId,
        lat: lat,
        lon: lon,
      );
      _sessionId = start.sessionId;

      _sub = _api.stream(start.streamId).listen(
        (event) {
          switch (event) {
            case TokenEvent(:final text):
              reply.text += text;
            case DoctorsEvent(:final doctors):
              reply.doctors = doctors;
            case ErrorEvent(:final message):
              reply.text += '\n⚠️ $message';
            case HeartbeatEvent():
              return; // nothing to redraw
          }
          notifyListeners();
        },
        onError: (e) {
          reply.text += '\n⚠️ $e';
          loading = false;
          notifyListeners();
        },
        onDone: () {
          loading = false;
          notifyListeners();
        },
      );
    } catch (e) {
      reply.text = 'Error: $e';
      loading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}