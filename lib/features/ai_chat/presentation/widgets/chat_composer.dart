import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Message input at the bottom of the chat (not interactive yet).
class ChatComposer extends StatelessWidget {
  const ChatComposer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.card),
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.fromLTRB(AppSpacing.m, 2, AppSpacing.xxs, 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.chatBorder),
        ),
        child: Row(
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: Text(
                'Message HealthFinder...',
                style: AppTextStyles.body.copyWith(color: AppColors.chatPlaceholder),
              ),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.chatAccent,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.arrow_forward, size: 20, color: AppColors.onAccent),
            ),
          ],
        ),
      ),
    );
  }
}
