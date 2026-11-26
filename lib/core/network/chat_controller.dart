import 'dart:async';
import 'package:flutter/foundation.dart';
import 'chat_api.dart';
import 'chat_models.dart';

class Message {
  final bool isUser;
  String text;
  List<Doctor> doctors;

  /// Set when the assistant asked where to search during this reply.
  LocationRequest? locationRequest;
  Message({required this.isUser, this.text = '', this.doctors = const []});
}

enum LocationRequestStatus {
  /// Waiting for the user's choice.
  pending,

  /// The choice is being read (GPS) or sent.
  sending,
  shared,
  declined,

  /// The server stopped waiting: timed out, or the reply has ended.
  expired,
}

/// The assistant's question "where should I search?" inside a reply.
class LocationRequest {
  LocationRequest({
    required this.requestId,
    this.reason,
    required this.textOffset,
    required this.remember,
    this.change = false,
  });

  final String requestId;
  final String? reason;

  /// "Remember for this chat" on the card: the choice then answers the next
  /// searches of this chat without asking.
  bool remember;

  /// The user asked to search somewhere else (see [LocationRequestEvent.change]).
  final bool change;

  /// Answered with the choice remembered for this chat, without the card.
  bool automatic = false;

  /// Length of the reply text when the question came: the text before it is
  /// shown above the card, the text after the answer below it.
  final int textOffset;
  LocationRequestStatus status = LocationRequestStatus.pending;

  /// What was shared, for the line that replaces the question.
  SharedLocationSource? sharedSource;

  /// Shown to the user only, e.g. the home address with the street.
  String? sharedLabel;

  bool get isOpen =>
      status == LocationRequestStatus.pending ||
      status == LocationRequestStatus.sending;
}

class ChatController extends ChangeNotifier {
  ChatController(this._api);
  final ChatApi _api;

  final List<Message> messages = [];
  String? _sessionId; // remembered for follow-up messages
  bool loading = false;
  StreamSubscription<ChatEvent>? _sub;

  /// Where to search for the rest of this chat, or null to ask each time.
  /// The server asks again for every reply; with a remembered choice the
  /// app answers by itself, with a fresh position. Cleared by [clear].
  LocationChoice? rememberedLocation;

  /// Initial state of "Remember for this chat" on a new card (a setting).
  bool rememberByDefault = true;

  /// Answers [request] with the remembered [choice] (reads the position,
  /// the home address). Set by the chat screen; without it the card is shown.
  Future<void> Function(LocationRequest request, LocationChoice choice)?
      answerRemembered;

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
            case LocationRequestEvent(
                :final requestId,
                :final reason,
                :final change,
              ):
              final request = reply.locationRequest = LocationRequest(
                requestId: requestId,
                reason: reason,
                textOffset: reply.text.length,
                remember: rememberedLocation != null || rememberByDefault,
                change: change,
              );
              final choice = rememberedLocation;
              final answer = answerRemembered;
              if (!change && choice != null && answer != null) {
                request.automatic = true;
                unawaited(answer(request, choice));
              }
            case HeartbeatEvent():
              return; // nothing to redraw
          }
          notifyListeners();
        },
        onError: (e) {
          reply.text += '\n⚠️ $e';
          _expireLocationRequest(reply);
          loading = false;
          notifyListeners();
        },
        onDone: () {
          _expireLocationRequest(reply);
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

  /// Marks [request] as being handled (e.g. while the GPS is read), so the
  /// card cannot be tapped twice. Returns false if it is no longer open.
  bool beginLocationAnswer(LocationRequest request) {
    if (request.status != LocationRequestStatus.pending) return false;
    request.status = LocationRequestStatus.sending;
    notifyListeners();
    return true;
  }

  /// Gives the card back to the user, e.g. after the permission was denied.
  void cancelLocationAnswer(LocationRequest request) {
    if (request.status != LocationRequestStatus.sending) return;
    request.status = LocationRequestStatus.pending;
    // An automatic answer that failed: the user chooses on the card.
    request.automatic = false;
    notifyListeners();
  }

  /// "Remember for this chat" on the card of [request].
  void setRemember(LocationRequest request, bool value) {
    request.remember = value;
    notifyListeners();
  }

  /// Changes the choice for the next searches of this chat (null: ask).
  void setRememberedLocation(LocationChoice? choice) {
    rememberedLocation = choice;
    notifyListeners();
  }

  /// Sends the user's choice for [request]; the reply then continues.
  /// [shownLabel] is what the card shows afterwards, on this device only.
  /// [choice] is what the user picked, remembered when [LocationRequest.remember]
  /// is on; it can differ from [answer] (the current position was not
  /// available, so the home address was sent).
  ///
  /// Returns false when the server no longer waits for it. Other errors
  /// (no connection) are rethrown and the card can be used again.
  Future<bool> answerLocation(
    LocationRequest request,
    LocationAnswer answer, {
    String? shownLabel,
    LocationChoice? choice,
  }) async {
    if (!request.isOpen) return false;
    request.status = LocationRequestStatus.sending;
    notifyListeners();

    try {
      await _api.answerLocation(request.requestId, answer);
    } on LocationRequestExpired {
      request.status = LocationRequestStatus.expired;
      notifyListeners();
      return false;
    } catch (_) {
      request.status = LocationRequestStatus.pending;
      notifyListeners();
      rethrow;
    }

    switch (answer) {
      case LocationShared(:final source):
        request.status = LocationRequestStatus.shared;
        request.sharedSource = source;
        request.sharedLabel = shownLabel;
      case LocationDeclined():
        request.status = LocationRequestStatus.declined;
    }
    final picked = choice ??
        switch (answer) {
          LocationShared(source: SharedLocationSource.current) =>
            LocationChoice.current,
          LocationShared(source: SharedLocationSource.home) =>
            LocationChoice.home,
          LocationDeclined() => LocationChoice.none,
        };
    rememberedLocation = request.remember ? picked : null;
    notifyListeners();
    return true;
  }

  void _expireLocationRequest(Message reply) {
    final request = reply.locationRequest;
    if (request != null && request.isOpen) {
      request.status = LocationRequestStatus.expired;
    }
  }

  void clear() {
    messages.clear();
    // A new chat is a new server session: its location is asked again.
    _sessionId = null;
    rememberedLocation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}