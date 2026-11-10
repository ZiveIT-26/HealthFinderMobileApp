import 'package:flutter/foundation.dart';

import 'home_mock_data.dart';

/// One saved mood entry, ready to be sent to the backend.
class MoodEntry {
  const MoodEntry({required this.mood, required this.note, required this.createdAt});

  final Mood mood;

  /// Empty when the user left no note.
  final String note;
  final DateTime createdAt;

  Map<String, Object> toJson() => {
        'mood': mood.name,
        'note': note,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Where mood entries are stored. Swap [MockMoodRepository] for an API-backed
/// implementation once the backend endpoint exists.
abstract interface class MoodRepository {
  Future<void> saveEntry(MoodEntry entry);
}

/// Keeps entries in memory and logs them, imitating a network call.
class MockMoodRepository implements MoodRepository {
  final List<MoodEntry> entries = [];

  @override
  Future<void> saveEntry(MoodEntry entry) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    entries.add(entry);
    debugPrint('Mood saved: ${entry.toJson()}');
  }
}
