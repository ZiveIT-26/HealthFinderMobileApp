import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';

/// Muted text for a missing value: "Not set", "Nothing added". Quieter than
/// the field labels, so empty data does not stand out.
class PlaceholderText extends StatelessWidget {
  const PlaceholderText(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  /// Also used as the hint of empty input fields.
  static TextStyle get style => AppTextStyles.body.copyWith(
        color: AppColors.secondaryText.withValues(alpha: 0.6),
      );

  @override
  Widget build(BuildContext context) =>
      Text(text, textAlign: textAlign, style: style);
}
