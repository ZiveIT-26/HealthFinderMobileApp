import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Тимчасова заглушка для екранів, які ще верстаються.
class ScreenPlaceholder extends StatelessWidget {
  const ScreenPlaceholder({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$name — in progress', style: AppTextStyles.body),
    );
  }
}
