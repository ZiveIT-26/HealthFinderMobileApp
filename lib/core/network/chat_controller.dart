import 'dart:async';

import 'package:flutter/foundation.dart';

import 'chat_api.dart';
import 'chat_cache_store.dart';
import 'chat_models.dart';

class Message {
  final bool isUser;
  String text;
  List<Doctor> doctors;

  /// Set when the assistant asked where to search during this reply.
  LocationRequest? locationRequest;
  Message({required this.isUser, this.text = '', this.doctors = const []});

  factory Message.fromHistory(HistoryMessage h) =>
      Message(isUser: h.isUser, text: h.content, doctors: h.doctors);
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
  ChatController(this._api, {ChatCacheStore? cacheStore})
    : _cacheStore = cacheStore;

  final ChatApi _api;
  final ChatCacheStore? _cacheStore;

  final List<Message> messages = [];
  String? _sessionId; // remembered for follow-up messages
  bool loading = false;
  StreamSubscription<ChatEvent>? _sub;
  bool backendAvailable = false;
  Object? availabilityError;
  Object? cacheError;
  bool _availabilityCheckInProgress = false;
  bool _disposed = false;

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
    final token = ++_operationToken;
    await _sub?.cancel();
    if (token != _operationToken) return;
    _sub = null;

    final userMessage = Message(isUser: true, text: prompt);
    messages.add(userMessage);
    final reply = Message(isUser: false); // filled in as tokens arrive
    messages.add(reply);
    loading = true;
    notifyListeners(); // tells the UI to redraw

    try {
      final previousSessionId = _sessionId;
      final start = await _api.startChat(
        prompt,
        sessionId: _sessionId,
        lat: lat,
        lon: lon,
      );
      if (token != _operationToken) return;
      _sessionId = start.sessionId;
      await _storeMessage(
        start.sessionId,
        userMessage,
        isNewSession: previousSessionId != start.sessionId,
      );
      if (token != _operationToken) return;

      var replyStored = false;
      void storeReply() {
        if (replyStored || (reply.text.isEmpty && reply.doctors.isEmpty))
          return;
        replyStored = true;
        unawaited(_storeMessage(start.sessionId, reply));
      }

      _sub = _api
          .stream(start.streamId)
          .listen(
            (event) {
              if (token != _operationToken) return;
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
              if (token != _operationToken) return;
              backendAvailable = false;
              availabilityError = e;
              reply.text += '\n⚠️ $e';
              _expireLocationRequest(reply);
              storeReply();
              loading = false;
              notifyListeners();
            },
            onDone: () {
              if (token != _operationToken) return;
              _expireLocationRequest(reply);
              storeReply();
              loading = false;
              notifyListeners();
            },
          );
    } catch (e) {
      if (token != _operationToken) return;
      backendAvailable = false;
      availabilityError = e;
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
    final picked =
        choice ??
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

  List<ChatSession> sessions = [];
  bool sessionsLoading = false;
  Object? sessionsError;
  bool sessionsFromCache = false;

  /// Invalidates pending sends and history loads when the active chat changes.
  int _operationToken = 0;

  String? get currentSessionId => _sessionId;

  Future<void> checkAvailability() async {
    if (_availabilityCheckInProgress) return;
    _availabilityCheckInProgress = true;
    try {
      await _api.checkAvailability();
      backendAvailable = true;
      availabilityError = null;
    } catch (e) {
      backendAvailable = false;
      availabilityError = e;
    } finally {
      _availabilityCheckInProgress = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> loadSessions() async {
    sessionsLoading = true;
    sessionsError = null;
    notifyListeners();
    try {
      sessions = await _api.fetchSessions();
      sessionsFromCache = false;
      backendAvailable = true;
      availabilityError = null;
      await _storeSessions(sessions);
    } catch (e) {
      backendAvailable = false;
      availabilityError = e;
      final cacheStore = _cacheStore;
      if (cacheStore == null) {
        sessionsError = e;
      } else {
        try {
          sessions = await cacheStore.loadSessions();
          sessionsFromCache = true;
          sessionsError = null;
        } catch (cacheException) {
          cacheError = cacheException;
          sessionsError = cacheException;
        }
      }
    }
    sessionsLoading = false;
    if (!_disposed) notifyListeners();
  }

  /// Opens a saved chat; the next [send] continues it (same sessionId).
  Future<void> openSession(String id) async {
    final token = ++_operationToken;
    await _sub?.cancel();
    _sub = null;
    loading = true;
    notifyListeners();

    Object? networkError;
    StackTrace? networkStack;
    if (backendAvailable) {
      try {
        final history = await _api.fetchHistory(id);
        if (token != _operationToken) return;
        _setHistory(id, history);
        await _storeHistory(id, history);
        loading = false;
        notifyListeners();
        return;
      } catch (error, stack) {
        if (token != _operationToken) return;
        networkError = error;
        networkStack = stack;
        backendAvailable = false;
        availabilityError = error;
      }
    }

    try {
      final history = await _cacheStore?.loadHistory(id);
      if (token != _operationToken) return;
      if (history != null) {
        _setHistory(id, history);
        sessionsFromCache = true;
        loading = false;
        notifyListeners();
        return;
      }
    } catch (error) {
      cacheError = error;
    }

    loading = false;
    notifyListeners();
    if (networkError != null) {
      Error.throwWithStackTrace(networkError, networkStack!);
    }
    throw ChatHistoryNotCachedException(id);
  }

  void _setHistory(String id, List<HistoryMessage> history) {
    messages
      ..clear()
      ..addAll(history.map(Message.fromHistory));
    _sessionId = id;
    rememberedLocation = null;
  }

  Future<void> _storeSessions(List<ChatSession> value) async {
    try {
      await _cacheStore?.saveSessions(value);
      cacheError = null;
    } catch (error) {
      cacheError = error;
    }
  }

  Future<void> _storeHistory(String id, List<HistoryMessage> history) async {
    try {
      await _cacheStore?.saveHistory(id, history);
      cacheError = null;
    } catch (error) {
      cacheError = error;
    }
  }

  Future<void> _storeMessage(
    String id,
    Message message, {
    bool isNewSession = false,
  }) async {
    try {
      await _cacheStore?.appendHistoryMessage(
        id,
        HistoryMessage(
          isUser: message.isUser,
          content: message.text,
          doctors: message.doctors,
        ),
        isNewSession: isNewSession,
      );
      cacheError = null;
    } catch (error) {
      cacheError = error;
    } finally {
      if (!_disposed) notifyListeners();
    }
  }

  Future<void> renameSession(String id, String title) async {
    await _api.renameSession(id, title);
    sessions = sessions
        .map(
          (session) => session.id == id
              ? ChatSession(
                  id: session.id,
                  title: title,
                  createdAt: session.createdAt,
                )
              : session,
        )
        .toList();
    await _storeSessions(sessions);
    notifyListeners();
  }

  Future<void> deleteSession(String id) async {
    await _api.deleteSession(id);
    sessions = sessions.where((s) => s.id != id).toList();
    await _storeSessions(sessions);
    if (id == _sessionId) await _resetChat();
    notifyListeners();
  }

  Future<void> deleteAllSessions() async {
    await _api.deleteAllSessions();
    sessions = [];
    await _storeSessions(sessions);
    await _resetChat();
    notifyListeners();
  }

  Future<void> _resetChat() async {
    _operationToken++;
    await _sub?.cancel();
    _sub = null;
    loading = false;
    clear();
  }

  void clear() {
    _operationToken++;
    unawaited(_sub?.cancel());
    _sub = null;
    loading = false;
    messages.clear();
    _sessionId = null;
    rememberedLocation = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _sub?.cancel();
    super.dispose();
  }
}

class ChatHistoryNotCachedException implements Exception {
  const ChatHistoryNotCachedException(this.sessionId);

  final String sessionId;

  @override
  String toString() =>
      'Chat history for $sessionId has not been cached on this device';
}
