import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/widgets/app_button.dart';

import '../../../core/theme/theme.dart';

/// Chat header: history button, title and "new chat" button (Figma
/// "Chat / Header").
///
/// Once the user chose where to search in this chat, a line under the title
/// shows it ([location]) and changes it at any moment. This line is not in
/// Figma yet.
class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    this.onNewChat,
    this.onHistory,
    this.location,
    this.onLocationTap,
  });

  /// Null disables the button (e.g. while a reply is streaming).
  final VoidCallback? onNewChat;

  /// Opens the chats history.
  final VoidCallback? onHistory;

  /// Where to search, e.g. "Near home"; null shows the title only.
  final String? location;

  /// Changes where to search.
  final VoidCallback? onLocationTap;

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
          Expanded(child: _titleAndLocation()),
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

  Widget _titleAndLocation() {
    final title = Text(
      'AI Health Assistant',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: AppTextStyles.body.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );

    final location = this.location;
    if (location == null) return title;

    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        title,
        // In the brand color with an arrow: it is a control, and has to be
        // noticed by older users too.
        Row(
          spacing: 2,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 15,
              color: AppColors.colorBrand,
            ),
            Flexible(
              child: Text(
                location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.meta.copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorBrand,
                ),
              ),
            ),
            if (onLocationTap != null)
              const Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.colorBrand,
              ),
          ],
        ),
      ],
    );

    final onTap = onLocationTap;
    if (onTap == null) return text;
    return Semantics(
      button: true,
      label: 'Where to search: $location. Change',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: ConstrainedBox(
          // The whole title block is the target, at least 48 high.
          constraints: const BoxConstraints(minHeight: 48),
          child: text,
        ),
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
