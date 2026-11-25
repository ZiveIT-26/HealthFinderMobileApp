import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'grouped_card.dart';
import 'placeholder_text.dart';

/// One row of an [InfoRowsCard]: a label with a value, or with a control
/// such as a switch, dropdown or input field. A null [value] without [trailing] is shown as "Not set".
class InfoRow {
  const InfoRow(this.label, this.value)
      : trailing = null,
        stacked = false;

  /// Row with a compact control instead of a text value: switch, dropdown,
  /// date.
  const InfoRow.control(this.label, Widget this.trailing)
      : value = null,
        stacked = false;

  /// Row with a text input under the label, across the full width.
  const InfoRow.field(this.label, Widget this.trailing)
      : value = null,
        stacked = true;

  final String label;
  final String? value;
  final Widget? trailing;
  final bool stacked;
}

/// [GroupedCard] with label/value rows
/// (medical information, personal information).
class InfoRowsCard extends StatelessWidget {
  const InfoRowsCard({super.key, required this.rows});

  final List<InfoRow> rows;

  @override
  Widget build(BuildContext context) {
    return GroupedCard(
      children: [
        for (final row in rows)
          Container(
            constraints: const BoxConstraints(minHeight: GroupedCard.tileMinHeight),
            padding: GroupedCard.tilePadding,
            alignment: Alignment.centerLeft,
            child: row.stacked ? _stacked(row) : _inline(row),
          ),
      ],
    );
  }

  /// Label above, input across the full width.
  static Widget _stacked(InfoRow row) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s,
        children: [
          Text(row.label, style: AppTextStyles.body),
          row.trailing!,
        ],
      );

  /// Label on the left, value or control on the right.
  static Widget _inline(InfoRow row) => Row(
        crossAxisAlignment: row.trailing == null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        spacing: 14,
        children: [
          Expanded(flex: 2, child: Text(row.label, style: AppTextStyles.body)),
          Expanded(
            flex: 3,
            child: row.trailing == null
                ? _value(row.value)
                : Align(alignment: Alignment.centerRight, child: row.trailing),
          ),
        ],
      );

  static Widget _value(String? value) => value == null
      ? const PlaceholderText('Not set', textAlign: TextAlign.right)
      : Text(value, style: AppTextStyles.detailRowValue, textAlign: TextAlign.right);
}
