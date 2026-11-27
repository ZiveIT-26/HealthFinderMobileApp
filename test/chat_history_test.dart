import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_cache_store.dart';
import 'package:health_finder/core/network/chat_controller.dart';
import 'package:health_finder/core/network/chat_models.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('first and follow-up messages use the active session id', () async {
    final requests = <http.Request>[];
    final api = ChatApi(
      'http://test',
      clientFactory: () => MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/chat') {
          final index = requests.where((r) => r.url.path == '/chat').length;
          return http.Response(
            jsonEncode({'streamId': 'stream-$index', 'sessionId': 'session-1'}),
            201,
          );
        }
        if (request.url.path.startsWith('/chat/stream/')) {
          return http.Response(
            'data: {"type":"token","text":"Reply"}\n\n',
            200,
          );
        }
        return http.Response('', 404);
      }),
    );
    final chat = ChatController(api);
    addTearDown(chat.dispose);

    await chat.send('First question');
    await Future<void>.delayed(const Duration(milliseconds: 10));
    await chat.send('Follow-up question');

    final chatRequests = requests
        .where((request) => request.url.path == '/chat')
        .toList();
    expect(jsonDecode(chatRequests[0].body), {'prompt': 'First question'});
    expect(jsonDecode(chatRequests[1].body), {
      'prompt': 'Follow-up question',
      'sessionId': 'session-1',
    });

    chat.clear();
    await chat.send('Start a new conversation');
    final updatedRequests = requests
        .where((request) => request.url.path == '/chat')
        .toList();
    expect(jsonDecode(updatedRequests[2].body), {
      'prompt': 'Start a new conversation',
    });
  });

  test('loads server sessions for the history sidebar', () async {
    final api = ChatApi(
      'http://test',
      clientFactory: () => MockClient((request) async {
        if (request.method == 'GET' && request.url.path == '/chat/sessions') {
          return http.Response(
            jsonEncode([
              {
                'id': 'session-1',
                'title': 'Doctor search',
                'createdAt': '2026-11-23T18:30:00.000Z',
              },
            ]),
            200,
          );
        }
        return http.Response('', 404);
      }),
    );
    final chat = ChatController(api);
    addTearDown(chat.dispose);

    await chat.loadSessions();

    expect(chat.sessions, hasLength(1));
    expect(chat.sessions.single.id, 'session-1');
    expect(chat.sessions.single.title, 'Doctor search');
    expect(chat.sessionsError, isNull);
  });

  test(
    'loads cached sessions and history when the backend is unavailable',
    () async {
      final cached = _MemoryChatCache(
        sessions: [
          ChatSession(
            id: 'cached-session',
            title: 'Cached chat',
            createdAt: DateTime(2026, 11, 23),
          ),
        ],
        histories: {
          'cached-session': const [
            HistoryMessage(isUser: true, content: 'Old question'),
            HistoryMessage(isUser: false, content: 'Old answer'),
          ],
        },
      );
      final chat = ChatController(
        ChatApi(
          'http://test',
          clientFactory: () => MockClient((_) async => http.Response('', 503)),
        ),
        cacheStore: cached,
      );
      addTearDown(chat.dispose);

      await chat.loadSessions();
      expect(chat.backendAvailable, isFalse);
      expect(chat.sessionsFromCache, isTrue);
      expect(chat.sessions.single.id, 'cached-session');
      expect(chat.sessionsError, isNull);

      await chat.openSession('cached-session');
      expect(chat.currentSessionId, 'cached-session');
      expect(chat.messages.map((message) => message.text), [
        'Old question',
        'Old answer',
      ]);
    },
  );

  test(
    'stores user and assistant messages under the returned session id',
    () async {
      final cached = _MemoryChatCache();
      final api = ChatApi(
        'http://test',
        clientFactory: () => MockClient((request) async {
          if (request.url.path == '/chat') {
            return http.Response(
              jsonEncode({'streamId': 'stream-1', 'sessionId': 'session-1'}),
              201,
            );
          }
          if (request.url.path == '/chat/stream/stream-1') {
            return http.Response(
              'data: {"type":"token","text":"Reply"}\n\n',
              200,
            );
          }
          return http.Response('', 404);
        }),
      );
      final chat = ChatController(api, cacheStore: cached);
      addTearDown(chat.dispose);

      await chat.send('Question');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await chat.send('Follow-up');
      await Future<void>.delayed(const Duration(milliseconds: 10));

      expect(cached.histories['session-1']!.map((message) => message.content), [
        'Question',
        'Reply',
        'Follow-up',
        'Reply',
      ]);
      expect(cached.histories['session-1']!.map((message) => message.isUser), [
        true,
        false,
        true,
        false,
      ]);
      expect(cached.newSessionFlags, [true, false, false, false]);
    },
  );

  test('availability follows the authenticated sessions endpoint', () async {
    var statusCode = 200;
    final api = ChatApi(
      'http://test',
      clientFactory: () =>
          MockClient((_) async => http.Response('[]', statusCode)),
    );
    final chat = ChatController(api);
    addTearDown(chat.dispose);

    await chat.checkAvailability();
    expect(chat.backendAvailable, isTrue);

    statusCode = 503;
    await chat.checkAvailability();
    expect(chat.backendAvailable, isFalse);
    expect(chat.availabilityError, isNotNull);
  });

  test('opening a saved session makes it the follow-up session', () async {
    final requests = <http.Request>[];
    final api = ChatApi(
      'http://test',
      clientFactory: () => MockClient((request) async {
        requests.add(request);
        if (request.url.path == '/chat/history/saved-session') {
          return http.Response(
            jsonEncode([
              {'role': 'user', 'content': 'Old question', 'payload': null},
              {'role': 'assistant', 'content': 'Old answer', 'payload': null},
            ]),
            200,
          );
        }
        if (request.url.path == '/chat') {
          return http.Response(
            jsonEncode({'streamId': 'stream-1', 'sessionId': 'saved-session'}),
            201,
          );
        }
        if (request.url.path == '/chat/stream/stream-1') {
          return http.Response('', 200);
        }
        return http.Response('', 404);
      }),
    );
    final chat = ChatController(api);
    addTearDown(chat.dispose);

    await chat.openSession('saved-session');
    expect(chat.currentSessionId, 'saved-session');
    expect(chat.messages.map((message) => message.text), [
      'Old question',
      'Old answer',
    ]);

    await chat.send('Continue this chat');

    final request = requests.singleWhere((r) => r.url.path == '/chat');
    expect(jsonDecode(request.body), {
      'prompt': 'Continue this chat',
      'sessionId': 'saved-session',
    });
  });
}

class _MemoryChatCache implements ChatCacheStore {
  _MemoryChatCache({
    List<ChatSession> sessions = const [],
    Map<String, List<HistoryMessage>> histories = const {},
  }) : sessions = sessions,
       histories = {
         for (final entry in histories.entries) entry.key: List.of(entry.value),
       };

  List<ChatSession> sessions;
  final Map<String, List<HistoryMessage>> histories;
  final List<bool> newSessionFlags = [];

  @override
  Future<void> appendHistoryMessage(
    String sessionId,
    HistoryMessage message, {
    required bool isNewSession,
  }) async {
    newSessionFlags.add(isNewSession);
    histories.putIfAbsent(sessionId, () => []).add(message);
  }

  @override
  Future<List<HistoryMessage>?> loadHistory(String sessionId) async =>
      histories[sessionId];

  @override
  Future<List<ChatSession>> loadSessions() async => sessions;

  @override
  Future<void> saveHistory(
    String sessionId,
    List<HistoryMessage> messages,
  ) async {
    histories[sessionId] = messages;
  }

  @override
  Future<void> saveSessions(List<ChatSession> value) async {
    sessions = value;
  }
}
