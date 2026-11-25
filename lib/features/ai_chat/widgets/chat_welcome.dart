import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/gradient_surface.dart';
import 'home_scaled.dart';

/// Hero card shown at the top while the conversation is empty
/// (Figma: Chat / Welcome hero). The mascot head overlaps the card's
/// top-left corner and the tail its bottom-right corner.
///
/// Scaled like the Home screen, see [HomeScaled].
class ChatGreeting extends StatelessWidget {
  const ChatGreeting({super.key});

  // The mascot and the space above the card are 0.8 of Figma, to keep the
  // card compact; the text keeps its Figma size for readability.

  /// Where the card starts below the top of the hero; the head fills it.
  static const _cardTop = 75.0;

  /// The head sticks out above the hero.
  static const _headOverhang = 12.0;
  static const _headWidth = 150.0;
  static const _tailWidth = 105.0;

  /// The tail sticks out below the card.
  static const _tailOverhang = 34.0;

  static const _cardRadius = BorderRadius.only(
    topLeft: Radius.circular(50),
    topRight: Radius.circular(AppRadius.card),
    bottomRight: Radius.circular(50),
    bottomLeft: Radius.circular(AppRadius.card),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      // No bottom padding: "Try asking" below adds its own, and the tail
      // overlaps it as in Figma.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        _headOverhang,
        AppSpacing.l,
        0,
      ),
      child: HomeScaled(child: _hero()),
    );
  }

  Widget _hero() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: _cardTop),
          child: GradientSurface(
            background: AppGradients.chatWelcome,
            borderRadius: _cardRadius,
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.m,
              AppSpacing.l,
              AppSpacing.m,
            ),
            child: const _GreetingText(),
          ),
        ),
        Positioned(
          left: AppSpacing.s,
          top: -_headOverhang,
          child: IgnorePointer(
            child: Image.asset(
              'assets/illustrations/chat_welcome_head.png',
              width: _headWidth,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        Positioned(
          right: -5,
          bottom: -_tailOverhang,
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
    );
  }
}

class _GreetingText extends StatelessWidget {
  const _GreetingText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSpacing.s,
      children: [
        // On the right, next to the mascot head.
        Text.rich(
          TextSpan(
            style: AppTextStyles.chatGreeting,
            children: [
              TextSpan(text: 'Hi! ', style: AppTextStyles.chatGreetingAccent),
              const TextSpan(text: 'I’m your\nHealth Assistant'),
            ],
          ),
          textAlign: TextAlign.right,
        ),
        Text(
          'Ask about symptoms, find a doctor near you or check what to do '
          'next. I’ll keep answers short and clear.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: _DisclaimerPill(),
        ),
      ],
    );
  }
}

class _DisclaimerPill extends StatelessWidget {
  const _DisclaimerPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(AppRadius.control),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: AppSpacing.xs,
        children: [
          const Icon(Icons.shield_outlined, size: 20, color: AppColors.actionPurple),
          Text('Not a diagnosis · Emergencies: 112', style: AppTextStyles.meta),
        ],
      ),
    );
  }
}
