import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'placeholder_text.dart';

/// Compact dropdown for a form row: shows the selected label, opens a list.
/// A `null` value in [options] is the "not set" choice.
class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint = 'Not set',
  });

  final T value;

  /// Value and label of every choice, in order.
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        value: value,
        isDense: true,
        borderRadius: BorderRadius.circular(AppRadius.field),
        dropdownColor: AppColors.white,
        icon: const Icon(Icons.expand_more, size: 20, color: AppColors.ink),
        style: AppTextStyles.detailRowValue,
        hint: Text(hint, style: PlaceholderText.style),
        items: [
          for (final (optionValue, label) in options)
            DropdownMenuItem<T>(
              value: optionValue,
              child: Text(
                label,
                style: optionValue == null
                    ? PlaceholderText.style
                    : AppTextStyles.detailRowValue,
              ),
            ),
        ],
        onChanged: (selected) => onChanged(selected as T),
      ),
    );
  }
}
