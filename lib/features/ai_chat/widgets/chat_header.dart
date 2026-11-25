import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/widgets/app_button.dart';

import '../../../core/theme/theme.dart';

/// Chat header: history button, title and "new chat" button.
class ChatHeader extends StatelessWidget {
  const ChatHeader({super.key, this.onNewChat, this.onHistory});

  /// Null disables the button (e.g. while a reply is streaming).
  final VoidCallback? onNewChat;

  /// Opens the chats history.
  final VoidCallback? onHistory;

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
          AppButton.icon(
            Icons.history,
            onTap: onHistory,
            size: AppButtonSize.medium,
            tooltip: 'Chats history',
          ),
          Expanded(
            child: Text(
              'AI Health Assistant',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.body.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          AppButton.icon(
            Icons.add,
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
