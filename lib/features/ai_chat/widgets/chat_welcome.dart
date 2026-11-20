import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';
import 'chat_header.dart'; // ChatAvatar

/// Shown above the composer while the conversation is empty.
class ChatGreeting extends StatelessWidget {
  const ChatGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSpacing.m,
          children: [
            const ChatAvatar(size: 64, radius: 20),
            Text('How can I help?', style: AppTextStyles.chatSender),
          ],
        ),
      ),
    );
  }
}

/// Shown below the composer while the conversation is empty.
class ChatSuggestions extends StatelessWidget {
  const ChatSuggestions({super.key, required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _suggestions = [
    'Find a dentist near me',
    'I need a cardiologist',
    'Where can I get a blood test?',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSpacing.s,
        children: [
          for (final s in _suggestions)
            SuggestionChip(label: s, onTap: () => onSelected(s)),
        ],
      ),
    );
  }
}

class SuggestionChip extends StatelessWidget {
  const SuggestionChip({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        borderRadius: BorderRadius.circular(17),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.card,
            vertical: AppSpacing.m,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17),
            border: Border.all(color: AppColors.chatBorder),
          ),
          child: Text(label, style: AppTextStyles.chatBody),
        ),
      ),
    );
  }
}