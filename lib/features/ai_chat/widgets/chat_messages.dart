import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/network/chat_models.dart';

import '../../../core/theme/theme.dart';
import 'chat_header.dart';
import 'doctor_card.dart';

/// User message: teal bubble aligned to the right.
class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.text});

  final String text;

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
            text,
            style: AppTextStyles.chatBody.copyWith(color: AppColors.chatInk),
          ),
        ),
      ),
    );
  }
}

/// Assistant reply: sender label, streamed text, doctor cards and a disclaimer.
class AssistantReply extends StatelessWidget {
  const AssistantReply({
    super.key,
    required this.text,
    this.doctors = const [],
    this.isStreaming = false,
  });

  final String text;
  final List<Doctor> doctors;
  final bool isStreaming;

  @override
  Widget build(BuildContext context) {
    // The backend streams plain text, so split on blank lines into paragraphs.
    final paragraphs = text
        .split(RegExp(r'\n\s*\n'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty);

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
        // Before the first token arrives
        if (text.isEmpty && isStreaming) const _TypingIndicator(),
        for (final paragraph in paragraphs)
          Text(paragraph, style: AppTextStyles.chatBody),
        for (final doctor in doctors) DoctorCard(doctor: doctor),
        if (!isStreaming && text.isNotEmpty)
          Text(
            'Not medical advice. Consult a professional.',
            style: AppTextStyles.chatFootnote,
          ),
      ],
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.chatAccent),
      ),
    );
  }
}