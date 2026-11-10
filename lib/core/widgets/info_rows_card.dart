import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// One label/value pair in an [InfoRowsCard].
class InfoRow {
  const InfoRow(this.label, this.value);

  final String label;
  final String value;
}

/// Card with label/value rows separated by thin lines
/// (profile details, medical information).
class InfoRowsCard extends StatelessWidget {
  const InfoRowsCard({
    super.key,
    required this.rows,
    this.tinted = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
  });

  final List<InfoRow> rows;

  /// Light lilac background instead of white.
  final bool tinted;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: tinted ? AppColors.infoCardTint : AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 20),
        ],
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: i == 0
                  ? null
                  : const BoxDecoration(
                      border: Border(top: BorderSide(color: AppColors.divider)),
                    ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 14,
                children: [
                  Expanded(flex: 2, child: Text(rows[i].label, style: AppTextStyles.infoLabel)),
                  Expanded(
                    flex: 3,
                    child: Text(
                      rows[i].value,
                      style: AppTextStyles.infoValue,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
