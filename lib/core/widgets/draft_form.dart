import 'package:material_ui/material_ui.dart';

import 'app_button.dart';

/// Edit-in-place form over one stored value [T] (a model with `==`).
///
/// Changes go to [draft]; [saveButton] appears while the draft differs from
/// the stored value and writes it with [writeDraft]. A new stored value
/// replaces the draft only when there are no unsaved changes.
mixin DraftForm<W extends StatefulWidget, T> on State<W> {
  T? _stored;
  T? _draft;
  bool _saving = false;

  /// Current edited value; null until the first stored value arrived.
  T? get draft => _draft;

  bool get hasChanges => _draft != null && _draft != _stored;

  /// Writes the draft to the database.
  Future<void> writeDraft(T draft);

  /// Called when the draft is replaced by a stored value, to update text
  /// controllers.
  void onDraftReset(T value) {}

  /// Pass every value read from the database.
  void receiveStored(T value) {
    final keepDraft = hasChanges;
    setState(() {
      _stored = value;
      if (!keepDraft) {
        _draft = value;
        onDraftReset(value);
      }
    });
  }

  void edit(T Function(T value) change) =>
      setState(() => _draft = change(_draft as T));

  /// "Save" for the page header, or null without changes.
  Widget? get saveButton => hasChanges
      ? AppButton.text('Save', onTap: _saving ? null : _save)
      : null;

  Future<void> _save() async {
    final draft = _draft;
    if (draft == null) return;
    setState(() => _saving = true);
    try {
      await writeDraft(draft);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
