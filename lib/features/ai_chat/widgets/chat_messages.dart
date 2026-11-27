import 'package:material_ui/material_ui.dart';
import 'package:health_finder/core/network/chat_models.dart';

import '../../../core/theme/theme.dart';
import 'chat_header.dart';
import 'doctor_card.dart';

/// User message: light purple bubble aligned to the right.
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
            color: AppColors.purpleSoft,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(17),
              topRight: Radius.circular(17),
              bottomLeft: Radius.circular(17),
              bottomRight: Radius.circular(5),
            ),
          ),
          child: Text(
            text,
            style: AppTextStyles.chatBody.copyWith(color: AppColors.ink),
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
    this.location,
    this.locationTextOffset = 0,
    this.awaitingLocation = false,
  });

  final String text;
  final List<Doctor> doctors;
  final bool isStreaming;

  /// The assistant's location question (`LocationRequestCard`), if it asked.
  final Widget? location;

  /// Where [location] goes in [text]: the text written before the question
  /// stays above the card, the rest of the answer comes below it.
  final int locationTextOffset;

  /// The question in [location] is still open: the reply waits for the user.
  final bool awaitingLocation;

  /// The backend streams plain text, so split on blank lines into paragraphs.
  static Iterable<Widget> _paragraphs(String text) => text
      .split(RegExp(r'\n\s*\n'))
      .map((p) => p.trim())
      .where((p) => p.isNotEmpty)
      .map((p) => Text(p, style: AppTextStyles.chatBody));

  @override
  Widget build(BuildContext context) {
    final location = this.location;
    final split = location == null
        ? text.length
        : locationTextOffset.clamp(0, text.length);

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
        if (text.isEmpty && isStreaming && location == null)
          const _TypingIndicator(),
        ..._paragraphs(text.substring(0, split)),
        if (location != null) ...[
          location,
          // The search continues after the answer.
          if (isStreaming && !awaitingLocation && split == text.length)
            const _TypingIndicator(),
          ..._paragraphs(text.substring(split)),
        ],
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
        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.colorBrand),
      ),
    );
  }
}