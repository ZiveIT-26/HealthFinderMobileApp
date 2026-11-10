import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_surface.dart';
import 'widget_header.dart';

/// "AI Health Assistant": intro text, illustration and a question field.
class AiAssistantWidget extends StatelessWidget {
  const AiAssistantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientSurface(
      background: AppGradients.ai,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.m,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Painted first so the header button stays on top of it.
              Positioned(
                top: -17,
                right: 4,
                width: 148,
                height: 145,
                child: Image.asset(
                  'assets/illustrations/ai_assistant.png',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: AppSpacing.xxs,
                children: [
                  WidgetHeader(
                    title: 'AI Health Assistant',
                    // Switches to the Chat tab (bottom navigation updates too).
                    action: WidgetArrowButton(
                      color: AppColors.ai,
                      onTap: () => context.go(AppRoutes.chat),
                    ),
                  ),
                  SizedBox(
                    width: 232,
                    child: Text(
                      'Ask about symptoms, find clinics, or get health information.',
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const _QuestionField(),
        ],
      ),
    );
  }
}

class _QuestionField extends StatelessWidget {
  const _QuestionField();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.m, 5, 5, 5),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.field),
      ),
      child: Row(
        spacing: AppSpacing.s,
        children: [
          Expanded(
            child: Text('Type your health question...', style: AppTextStyles.body),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.ai,
              borderRadius: BorderRadius.circular(AppRadius.control),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 20,
              color: AppColors.onAccent,
            ),
          ),
        ],
      ),
    );
  }
}
