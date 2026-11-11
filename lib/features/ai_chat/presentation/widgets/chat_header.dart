import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Chat header: robot avatar and title.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        spacing: AppSpacing.m,
        children: [
          const ChatAvatar(size: 48, radius: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Health Assistant', style: AppTextStyles.chatTitle),
                Text('Care guidance & clinic finder', style: AppTextStyles.chatSubtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Head of the AI assistant mascot (same character as on the Home widget),
/// clipped into a rounded square.
class ChatAvatar extends StatelessWidget {
  const ChatAvatar({super.key, required this.size, required this.radius});

  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppGradients.chatAvatar),
        child: Image.asset(
          'assets/illustrations/chat_avatar.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
}
