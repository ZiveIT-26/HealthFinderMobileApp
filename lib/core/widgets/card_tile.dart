import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'grouped_card.dart';
import 'placeholder_text.dart';

/// One row of a [GroupedCard]: title, optional subtitle and a trailing
/// widget (switch, value, chevron).
class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.titleColor,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  /// Dims the row and ignores taps.
  final bool enabled;

  /// Overrides the title color, e.g. for a destructive action.
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: GroupedCard.tileMinHeight),
      padding: GroupedCard.tilePadding,
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(
                  title,
                  style: AppTextStyles.detailLabel.copyWith(color: titleColor),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTextStyles.body,
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: IgnorePointer(
        ignoring: !enabled,
        child: onTap == null ? row : InkWell(onTap: onTap, child: row),
      ),
    );
  }
}

/// Row of an empty list: "Nothing added".
class EmptyCardTile extends StatelessWidget {
  const EmptyCardTile({super.key, this.text = 'Nothing added'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: GroupedCard.tileMinHeight),
      padding: GroupedCard.tilePadding,
      alignment: Alignment.centerLeft,
      child: PlaceholderText(text),
    );
  }
}
