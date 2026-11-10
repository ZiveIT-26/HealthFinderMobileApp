import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme.dart';

/// Шапка внутрішньої сторінки: кнопка "назад" + заголовок.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screen,
        vertical: AppSpacing.m,
      ),
      child: Row(
        spacing: AppSpacing.m,
        children: [
          _BackButton(onTap: () => context.pop()),
          Expanded(child: Text(title, style: AppTextStyles.pageTitle)),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppRadius.field);
    return Material(
      color: AppColors.surface,
      borderRadius: radius,
      elevation: 1,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: radius,
        onTap: onTap,
        child: const SizedBox.square(
          dimension: 36,
          child: Icon(Icons.chevron_left, color: AppColors.ink),
        ),
      ),
    );
  }
}
