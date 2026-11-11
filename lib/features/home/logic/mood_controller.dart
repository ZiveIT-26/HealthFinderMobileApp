import 'package:flutter/foundation.dart';

import '../data/home_mock_data.dart';
import '../data/mood_repository.dart';

enum MoodSaveStatus { idle, saving, saved, error }

/// State of the "Mood Today" widget: selected mood, note and save status.
class MoodController extends ChangeNotifier {
  MoodController(this._repository);

  final MoodRepository _repository;

  Mood? _selected;
  String _note = '';
  MoodSaveStatus _status = MoodSaveStatus.idle;

  Mood? get selected => _selected;
  String get note => _note;
  MoodSaveStatus get status => _status;

  bool get canSave => _selected != null && _status != MoodSaveStatus.saving;

  /// Tapping the selected mood again clears the selection.
  void select(Mood mood) {
    _selected = _selected == mood ? null : mood;
    _markDirty();
  }

  void updateNote(String value) {
    _note = value;
    _markDirty();
  }

  Future<void> save() async {
    final mood = _selected;
    if (mood == null || _status == MoodSaveStatus.saving) return;

    _status = MoodSaveStatus.saving;
    notifyListeners();
    try {
      await _repository.saveEntry(
        MoodEntry(mood: mood, note: _note.trim(), createdAt: DateTime.now()),
      );
      _status = MoodSaveStatus.saved;
    } catch (_) {
      _status = MoodSaveStatus.error;
    }
    notifyListeners();
  }

  /// Any edit after a save turns the button back into "Save".
  void _markDirty() {
    if (_status != MoodSaveStatus.saving) _status = MoodSaveStatus.idle;
    notifyListeners();
  }
}
