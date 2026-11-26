import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/card_tile.dart';

/// Row with a switch. Tapping anywhere on the row toggles it.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CardTile(
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      onTap: () => onChanged(!value),
      trailing: AppSwitch(value: value, onChanged: onChanged),
    );
  }
}

/// Row that shows the current value and opens a picker on tap.
class SettingsValueTile extends StatelessWidget {
  const SettingsValueTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final String value;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return CardTile(
      title: title,
      subtitle: subtitle,
      enabled: enabled,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 2,
        children: [
          Text(value, style: AppTextStyles.detailRowValue),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.ink),
        ],
      ),
    );
  }
}

/// Row that opens a page or an external link. Disabled while [onTap] is null.
class SettingsLinkTile extends StatelessWidget {
  const SettingsLinkTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.external = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Shows an "opens outside the app" icon instead of a chevron.
  final bool external;

  @override
  Widget build(BuildContext context) {
    return CardTile(
      title: title,
      subtitle: subtitle,
      enabled: onTap != null,
      onTap: onTap,
      trailing: Icon(
        external ? Icons.open_in_new : Icons.chevron_right,
        size: external ? 18 : 20,
        color: AppColors.ink,
      ),
    );
  }
}

/// One choice in [showOptionsSheet].
class SheetOption<T> {
  const SheetOption(this.value, this.label);

  final T value;
  final String label;
}

/// Bottom sheet with a single-choice list. Returns the picked option, or
/// null if the sheet was dismissed.
Future<SheetOption<T>?> showOptionsSheet<T>({
  required BuildContext context,
  required String title,
  required List<SheetOption<T>> options,
  required T selected,
  String? note,
}) {
  return showModalBottomSheet<SheetOption<T>>(
    context: context,
    backgroundColor: AppColors.white,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: AppTextStyles.detailHeading),
            const SizedBox(height: AppSpacing.s),
            for (final option in options)
              _OptionRow(
                label: option.label,
                selected: option.value == selected,
                onTap: () => Navigator.of(context).pop(option),
              ),
            if (note != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(note, style: AppTextStyles.body),
            ],
          ],
        ),
      ),
    ),
  );
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.field),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
          child: Row(
            spacing: 12,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 22,
                color: AppColors.colorBrand,
              ),
              Expanded(
                child: Text(
                  label,
                  style: selected ? AppTextStyles.label : AppTextStyles.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
