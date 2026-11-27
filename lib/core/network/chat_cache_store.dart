import 'chat_models.dart';

/// Local persistence contract for server-owned chat sessions and histories.
abstract interface class ChatCacheStore {
  Future<List<ChatSession>> loadSessions();
  Future<void> saveSessions(List<ChatSession> sessions);
  Future<List<HistoryMessage>?> loadHistory(String sessionId);
  Future<void> saveHistory(String sessionId, List<HistoryMessage> messages);
  Future<void> appendHistoryMessage(
    String sessionId,
    HistoryMessage message, {
    required bool isNewSession,
  });
}
