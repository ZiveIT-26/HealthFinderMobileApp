import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Switch in the brand colors.
class AppSwitch extends StatelessWidget {
  const AppSwitch({super.key, required this.value, required this.onChanged});

  final bool value;

  /// Null disables the switch.
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppColors.colorBrand,
      inactiveTrackColor: AppColors.colorSoft,
      inactiveThumbColor: AppColors.colorBrand,
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    );
  }
}
