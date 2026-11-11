import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Section title on detail pages, with the top spacing from Figma.
class DetailHeading extends StatelessWidget {
  const DetailHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 9),
      child: Text(text, style: AppTextStyles.detailHeading),
    );
  }
}
