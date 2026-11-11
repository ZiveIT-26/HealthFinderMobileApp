import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../data/chat_mock_data.dart';
import 'chat_header.dart';

/// User message: teal bubble aligned to the right.
class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.message});

  final UserMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.card, vertical: AppSpacing.m),
          decoration: const BoxDecoration(
            gradient: AppGradients.chatUserBubble,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Text(
            message.text,
            style: AppTextStyles.chatBody.copyWith(color: AppColors.chatInk),
          ),
        ),
      ),
    );
  }
}

/// Assistant reply: sender label, text, optional warning, clinic card and footnote.
class AssistantReply extends StatelessWidget {
  const AssistantReply({super.key, required this.message});

  final AssistantMessage message;

  @override
  Widget build(BuildContext context) {
    final warning = message.warning;
    final clinic = message.clinic;
    final footnote = message.footnote;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 11,
      children: [
        Row(
          spacing: 7,
          children: [
            const ChatAvatar(size: 36, radius: 12),
            Text('HealthFinder AI', style: AppTextStyles.chatSender),
          ],
        ),
        for (final paragraph in message.paragraphs)
          Text(paragraph, style: AppTextStyles.chatBody),
        if (warning != null) _WarningNote(warning: warning),
        if (clinic != null) _ClinicCard(clinic: clinic),
        if (footnote != null) Text(footnote, style: AppTextStyles.chatFootnote),
      ],
    );
  }
}

class _WarningNote extends StatelessWidget {
  const _WarningNote({required this.warning});

  final ChatWarning warning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 13, 13, 10),
      decoration: const BoxDecoration(
        color: AppColors.chatWarning,
        borderRadius: BorderRadius.horizontal(right: Radius.circular(9)),
      ),
      child: Text.rich(
        TextSpan(
          style: AppTextStyles.chatBody.copyWith(color: AppColors.brandDark),
          children: [
            // Bold Inter comes from its own style: google_fonts registers
            // each weight as a separate font family.
            TextSpan(
              text: warning.title,
              style: AppTextStyles.chatSender.copyWith(
                height: AppTextStyles.chatBody.height,
                color: AppColors.brandDark,
              ),
            ),
            TextSpan(text: warning.text),
          ],
        ),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  const _ClinicCard({required this.clinic});

  final ClinicRecommendation clinic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppSpacing.card, 17, AppSpacing.card, AppSpacing.card),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Color(0x0F6D5085), offset: Offset(0, 7), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.xxs,
        children: [
          Text(clinic.category, style: AppTextStyles.chatEyebrow),
          Text(clinic.doctor, style: AppTextStyles.chatCardTitle),
          Text(
            clinic.clinic,
            style: AppTextStyles.chatMeta.copyWith(color: AppColors.chatFootnote),
          ),
          _MetaLine(icon: Icons.location_on_outlined, text: clinic.address),
          _MetaLine(icon: Icons.schedule, text: clinic.hours),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              clinic.description,
              style: AppTextStyles.chatBody.copyWith(color: AppColors.chatDescription),
            ),
          ),
          Material(
            color: AppColors.chatAccent,
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              onTap: () => context.push(AppRoutes.clinicDetails(clinic.id)),
              child: SizedBox(
                height: 38,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: AppSpacing.s,
                  children: [
                    Text('View Clinic', style: AppTextStyles.chatButton),
                    const Icon(Icons.chevron_right, size: 20, color: AppColors.onAccent),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.l),
            child: Row(
              spacing: AppSpacing.xs,
              children: [
                const Icon(Icons.verified_user_outlined, size: 20, color: AppColors.chatAccentDark),
                Text(
                  clinic.source,
                  style: AppTextStyles.chatMeta.copyWith(color: AppColors.chatLink),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Icon above a line of text, as in the Figma card.
class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.chatMeta),
          Text(text, style: AppTextStyles.chatMeta),
        ],
      ),
    );
  }
}
