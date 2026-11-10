import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// White rounded card with a soft shadow, used on detail pages.
class ContentCard extends StatelessWidget {
  const ContentCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(15),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 20),
        ],
      ),
      child: child,
    );
  }
}
