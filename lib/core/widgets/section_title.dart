import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'grouped_card.dart';

/// Uppercase section title on the profile pages: "MY HEALTH", "NOTIFICATIONS".
/// [trailing] sits at the right end, e.g. an "add" button of a list.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 9, 2, 0),
      child: Row(
        spacing: AppSpacing.m,
        children: [
          Expanded(
            child: Text(title.toUpperCase(), style: AppTextStyles.groupTitle),
          ),
          // Lined up with the controls inside the cards below (switches).
          if (trailing case final trailing?)
            Padding(
              padding: EdgeInsets.only(right: GroupedCard.tilePadding.right - 2),
              child: trailing,
            ),
        ],
      ),
    );
  }
}
