import 'package:flutter/material.dart';
import 'package:health_finder/core/widgets/app_button.dart';

import '../../../core/theme/theme.dart';

/// Chat header: robot avatar and title.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, this.onNewChat});

  /// Null disables the button (e.g. while a reply is streaming).
  final VoidCallback? onNewChat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppButton(
            icon: Icons.history,
            onTap: onNewChat,
            size: AppButtonSize.medium,
            tooltip: 'Chats history',
          ),
          AppButton(
            icon: Icons.add,
            onTap: onNewChat,
            size: AppButtonSize.medium,
            tooltip: 'New chat',
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
