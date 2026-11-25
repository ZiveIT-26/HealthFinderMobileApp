import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/session/current_user.dart';
import 'models/chat_cache.dart';

/// A chat as returned by `GET /chat/sessions`.
typedef ServerChat = ({String sessionId, String? title, DateTime createdAt});

/// Local copy of the signed-in user's chats, for offline reading.
///
/// Screens read from here; network code writes the results of
/// `GET /chat/sessions`, `GET /chat/history/:id` and the chat stream into it.
/// The cache belongs to the profile row and is deleted with it on sign-out.
class ChatCacheRepository {
  ChatCacheRepository(this._db);

  final AppDatabase _db;

  // ---------------------------------------------------------------------------
  // Reading
  // ---------------------------------------------------------------------------

  /// Newest first, like the backend list.
  Stream<List<Chat>> watchChats() {
    final query = _db.select(_db.chats)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toChat).toList());
  }

  Future<Chat?> chatBySession(String sessionId) async {
    final row = await (_db.select(_db.chats)
          ..where((t) => t.serverId.equals(sessionId)))
        .getSingleOrNull();
    return row == null ? null : _toChat(row);
  }

  /// Messages of a chat in order, with their clinics. Emits again after every
  /// change of the messages or clinics.
  Stream<List<ChatMessage>> watchMessages(String chatId) async* {
    yield await _loadMessages(chatId);
    final updates = _db.tableUpdates(
      TableUpdateQuery.onAllTables([_db.messages, _db.clinics]),
    );
    await for (final _ in updates) {
      yield await _loadMessages(chatId);
    }
  }

  /// For the clinic details screen, by the local clinic id.
  Future<CachedClinic?> clinic(String id) async {
    final row = await (_db.select(_db.clinics)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _toClinic(row);
  }

  // ---------------------------------------------------------------------------
  // Writing
  // ---------------------------------------------------------------------------

  /// Stores the result of `GET /chat/sessions`: adds and updates chats, and
  /// deletes chats that are no longer on the server, with their messages.
  Future<void> saveChatList(List<ServerChat> chats) {
    return _db.transaction(() async {
      final profileId = await _profileId();
      final now = DateTime.now();
      for (final chat in chats) {
        await _db.into(_db.chats).insert(
              ChatsCompanion.insert(
                profileId: profileId,
                serverId: chat.sessionId,
                title: Value(chat.title),
                createdAt: chat.createdAt,
                fetchedAt: now,
              ),
              onConflict: DoUpdate(
                (_) => ChatsCompanion(
                  title: Value(chat.title),
                  createdAt: Value(chat.createdAt),
                  fetchedAt: Value(now),
                ),
                target: [_db.chats.serverId],
              ),
            );
      }
      final ids = chats.map((c) => c.sessionId).toList();
      await (_db.delete(_db.chats)..where((t) => t.serverId.isNotIn(ids)))
          .go();
    });
  }

  /// Stores the result of `GET /chat/history/:sessionId`. The backend gives
  /// no ids, so the chat's messages are replaced as a whole.
  Future<void> replaceHistory(String sessionId, List<ChatMessage> messages) {
    return _db.transaction(() async {
      final chatId = await _requireChatId(sessionId);
      await (_db.delete(_db.messages)..where((t) => t.chatId.equals(chatId)))
          .go();
      for (var i = 0; i < messages.length; i++) {
        await _insertMessage(chatId, i, messages[i]);
      }
      await (_db.update(_db.chats)..where((t) => t.id.equals(chatId)))
          .write(ChatsCompanion(historyFetchedAt: Value(DateTime.now())));
    });
  }

  /// A new chat started on this device (`POST /chat` returned a new
  /// `sessionId`). Returns the local chat id; an existing chat is kept.
  Future<String> startChat(String sessionId) {
    return _db.transaction(() async {
      final now = DateTime.now();
      await _db.into(_db.chats).insert(
            ChatsCompanion.insert(
              profileId: await _profileId(),
              serverId: sessionId,
              createdAt: now,
              fetchedAt: now,
              // Nothing to load: the chat is new.
              historyFetchedAt: Value(now),
            ),
            mode: InsertMode.insertOrIgnore,
          );
      return _requireChatId(sessionId);
    });
  }

  /// Adds the user's prompt, or the assistant's reply once its stream has
  /// ended, at the end of the chat. A broken stream is fixed by the next
  /// [replaceHistory].
  Future<void> appendMessage(String sessionId, ChatMessage message) {
    return _db.transaction(() async {
      final chatId = await _requireChatId(sessionId);
      final maxPosition = _db.messages.position.max();
      final last = await (_db.selectOnly(_db.messages)
            ..addColumns([maxPosition])
            ..where(_db.messages.chatId.equals(chatId)))
          .map((row) => row.read(maxPosition))
          .getSingle();
      await _insertMessage(chatId, (last ?? -1) + 1, message);
    });
  }

  /// From the SSE `title` event or after `PATCH /chat/sessions/:id`.
  Future<void> setTitle(String sessionId, String title) {
    return (_db.update(_db.chats)..where((t) => t.serverId.equals(sessionId)))
        .write(ChatsCompanion(title: Value(title)));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<String> _profileId() async {
    final row = await (_db.select(_db.profiles)..limit(1)).getSingleOrNull();
    if (row == null) throw const NotSignedInException();
    return row.id;
  }

  Future<String> _requireChatId(String sessionId) async {
    final row = await (_db.select(_db.chats)
          ..where((t) => t.serverId.equals(sessionId)))
        .getSingleOrNull();
    if (row == null) throw StateError('Chat $sessionId is not cached');
    return row.id;
  }

  Future<void> _insertMessage(
    String chatId,
    int position,
    ChatMessage message,
  ) async {
    final row = await _db.into(_db.messages).insertReturning(
          MessagesCompanion.insert(
            chatId: chatId,
            position: position,
            role: message.role,
            body: message.text,
          ),
        );
    for (var i = 0; i < message.clinics.length; i++) {
      final clinic = message.clinics[i];
      await _db.into(_db.clinics).insert(
            ClinicsCompanion.insert(
              messageId: row.id,
              position: i,
              name: clinic.name,
              speciality: clinic.speciality,
              address: clinic.address,
              url: clinic.url,
              phone: Value(clinic.phone),
              email: Value(clinic.email),
              additionalInfo: Value(clinic.additionalInfo),
            ),
          );
    }
  }

  Future<List<ChatMessage>> _loadMessages(String chatId) async {
    final messages = await (_db.select(_db.messages)
          ..where((t) => t.chatId.equals(chatId))
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();
    if (messages.isEmpty) return const [];

    final clinics = await (_db.select(_db.clinics)
          ..where((t) => t.messageId.isIn(messages.map((m) => m.id)))
          ..orderBy([(t) => OrderingTerm.asc(t.position)]))
        .get();
    final byMessage = <String, List<CachedClinic>>{};
    for (final clinic in clinics) {
      byMessage.putIfAbsent(clinic.messageId, () => []).add(_toClinic(clinic));
    }

    return [
      for (final m in messages)
        ChatMessage(
          role: m.role,
          text: m.body,
          clinics: byMessage[m.id] ?? const [],
        ),
    ];
  }

  static Chat _toChat(ChatRow row) => Chat(
        id: row.id,
        sessionId: row.serverId,
        title: row.title,
        createdAt: row.createdAt,
        historyLoaded: row.historyFetchedAt != null,
      );

  static CachedClinic _toClinic(ClinicRow row) => CachedClinic(
        id: row.id,
        name: row.name,
        speciality: row.speciality,
        address: row.address,
        url: row.url,
        phone: row.phone,
        email: row.email,
        additionalInfo: row.additionalInfo,
      );
}
