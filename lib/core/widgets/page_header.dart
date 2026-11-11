import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/theme.dart';

/// Inner page header: back button plus title.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, 8.5, AppSpacing.l, 13.5),
      child: Row(
        spacing: 9,
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
    final radius = BorderRadius.circular(13);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(color: Color(0x0D6D5085), offset: Offset(0, 4), blurRadius: 13),
        ],
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: const SizedBox.square(
            dimension: 36,
            child: Icon(Icons.chevron_left, size: 20, color: AppColors.brand),
          ),
        ),
      ),
    );
  }
}
