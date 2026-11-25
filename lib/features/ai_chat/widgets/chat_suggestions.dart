import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/theme/app_colors.dart';
import 'package:health_finder/core/theme/app_spacing.dart';
import 'package:health_finder/core/theme/app_text_styles.dart';

import 'suggestion_chip.dart';

class ChatSuggestions extends StatelessWidget {
  const ChatSuggestions({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _suggestions = [
    'Who treats frequent headaches?',
    'Neurologist in Košice',
    'Dentist open today',
    'GP accepting new patients',
    'Pediatrician near me',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.m,
        children: [
          Text(
            'Try asking',
            style: AppTextStyles.body.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final s in _suggestions)
                SuggestionChip(label: s, onTap: () => onSelected(s)),
            ],
          ),
        ],
      ),
    );
  }
}