import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_surface.dart';
import '../../data/home_mock_data.dart';
import '../../data/mood_repository.dart';
import '../../logic/mood_controller.dart';
import 'widget_header.dart';

/// "Mood Today": mood picker and note. Selection and note live in
/// [MoodController]; "Save" sends them through the [MoodRepository].
class MoodWidget extends StatefulWidget {
  const MoodWidget({super.key, this.repository});

  /// Defaults to the in-memory mock until the backend is ready.
  final MoodRepository? repository;

  @override
  State<MoodWidget> createState() => _MoodWidgetState();
}

class _MoodWidgetState extends State<MoodWidget> {
  late final MoodController _controller =
      MoodController(widget.repository ?? MockMoodRepository());

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientSurface(
      background: AppGradients.mood,
      child: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSpacing.s,
          children: [
            const WidgetHeader(
              title: 'Mood Today',
              action: WidgetArrowButton(color: AppColors.mood),
            ),
            // Options share the available width equally.
            Row(
              children: [
                for (final mood in Mood.values)
                  Expanded(
                    child: _MoodOption(
                      mood: mood,
                      isSelected: mood == _controller.selected,
                      onTap: () => _controller.select(mood),
                    ),
                  ),
              ],
            ),
            _NoteField(controller: _controller),
          ],
        ),
      ),
    );
  }
}

class _MoodOption extends StatelessWidget {
  const _MoodOption({
    required this.mood,
    required this.isSelected,
    required this.onTap,
  });

  final Mood mood;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: mood.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          spacing: AppSpacing.xxs,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isSelected ? 1 : 0.5,
              child: Image.asset(
                // Source files are 192 px (4x), shown at 48 so they stay sharp on dense screens.
                isSelected ? mood.selectedAsset : mood.asset,
                width: 48,
                height: 48,
                filterQuality: FilterQuality.medium,
                gaplessPlayback: true,
              ),
            ),
            Text(mood.label, style: AppTextStyles.meta, maxLines: 1),
          ],
        ),
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({required this.controller});

  final MoodController controller;

  @override
  Widget build(BuildContext context) {
    final status = controller.status;
    final label = switch (status) {
      MoodSaveStatus.saved => 'Saved',
      MoodSaveStatus.error => 'Retry',
      _ => 'Save',
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.m, 5, 5, 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        spacing: AppSpacing.s,
        children: [
          Expanded(
            child: TextField(
              onChanged: controller.updateNote,
              style: AppTextStyles.body.copyWith(color: AppColors.ink),
              textInputAction: TextInputAction.done,
              maxLines: 1,
              decoration: InputDecoration.collapsed(
                hintText: 'Note (optional)',
                hintStyle: AppTextStyles.body,
              ),
            ),
          ),
          // Disabled until a mood is picked (40% opacity, as in Figma).
          Opacity(
            opacity: controller.canSave ? 1 : 0.4,
            child: Material(
              color: status == MoodSaveStatus.saving ? AppColors.moodPressed : AppColors.mood,
              borderRadius: BorderRadius.circular(AppRadius.control),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.control),
                onTap: controller.canSave ? controller.save : null,
                child: Container(
                  height: 36,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: AppTextStyles.label.copyWith(color: AppColors.onAccent),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
