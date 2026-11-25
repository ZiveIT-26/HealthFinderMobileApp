import 'package:material_ui/material_ui.dart';

import '../formatting/dates.dart';
import '../theme/theme.dart';
import 'placeholder_text.dart';

/// Date value of a form row: tap opens a date picker, the cross clears it.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
  });

  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  /// Where the picker opens when there is no value; [firstDate] by default.
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    final value = this.value;
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSpacing.xxs,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(AppRadius.control),
          onTap: () => _pick(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: AppSpacing.xs,
            children: [
              value == null
                  ? const PlaceholderText('Not set')
                  : Text(formatDate(value), style: AppTextStyles.detailRowValue),
              const Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.ink),
            ],
          ),
        ),
        if (value != null)
          IconButton(
            onPressed: () => onChanged(null),
            tooltip: 'Clear',
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.close, size: 18, color: AppColors.ink),
          ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final initial = value;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial != null && !initial.isBefore(firstDate) && !initial.isAfter(lastDate)
          ? initial
          : initialDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) onChanged(picked);
  }
}
