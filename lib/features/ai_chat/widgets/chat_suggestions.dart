import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import 'home_scaled.dart';
import 'suggestion_chip.dart';

/// "Try asking" with suggestion chips (Figma: Chat · AI · Welcome).
/// Scaled like the Home screen, see [HomeScaled].
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
      padding: const EdgeInsets.all(AppSpacing.l),
      child: HomeScaled(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: AppSpacing.l,
          children: [
            Text('Try asking', style: AppTextStyles.title),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final s in _suggestions)
                  SuggestionChip(label: s, onTap: () => onSelected(s)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
