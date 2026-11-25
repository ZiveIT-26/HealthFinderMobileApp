import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

/// Hero card shown at the top while the conversation is empty.
/// The mascot head overlaps the card's top-left corner and the tail
/// overlaps its bottom-right corner.
class ChatGreeting extends StatelessWidget {
  const ChatGreeting({super.key});

  static const _cardRadius = 28.0;
  static const _headWidth = 190.0;
  static const _tailWidth = 135.0;

  /// How far the head sticks out above the card.
  static const _headOverhang = 80.0;

  /// How far the tail sticks out below the card.
  static const _tailOverhang = 30.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.l,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Card
          Padding(
            padding: const EdgeInsets.only(
              top: _headOverhang,
              bottom: _tailOverhang,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.l,
                AppSpacing.l,
                AppSpacing.l,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_cardRadius),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.welcomeCardTop,
                    AppColors.welcomeCardMiddle,
                    AppColors.welcomeCardBottom,
                  ],
                  stops: [0, 0.45, 1],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: AppSpacing.m,
                children: [
                  // Title is on the right, next to the mascot head.
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.m),
                    child: Text(
                      'Hi! I’m your\nHealth Assistant',
                      textAlign: TextAlign.right,
                      style: AppTextStyles.body.copyWith(
                        fontSize: 24,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  Text(
                    'Ask about symptoms, find a doctor near you or check '
                    'what to do next. I’ll keep answers short and clear.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body.copyWith(
                      fontSize: 15,
                      height: 1.35,
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: _DisclaimerPill(),
                  ),
                ],
              ),
            ),
          ),

          // Mascot head (top-left, overlaps the card)
          Positioned(
            left: 0,
            top: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/illustrations/chat_welcome_head.png',
                width: _headWidth,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),

          // Mascot tail (bottom-right, overlaps the card)
          Positioned(
            right: -6,
            bottom: 0,
            child: IgnorePointer(
              child: Image.asset(
                'assets/illustrations/chat_welcome_tail.png',
                width: _tailWidth,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisclaimerPill extends StatelessWidget {
  const _DisclaimerPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.s,
          children: [
            const Icon(
              Icons.shield_outlined,
              size: 20,
              color: AppColors.actionPurple,
            ),
            Text(
              'Not a diagnosis · Emergencies: 112',
              style: AppTextStyles.body.copyWith(
                fontSize: 14,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}