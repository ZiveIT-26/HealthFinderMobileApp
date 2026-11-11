import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../data/chat_mock_data.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';

class AiChatScreen extends StatelessWidget {
  const AiChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const messages = ChatMockData.messages;

    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ChatHeader(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(17, 28, 17, AppSpacing.l),
                itemCount: messages.length,
                separatorBuilder: (_, _) => const SizedBox(height: 20),
                itemBuilder: (context, index) => switch (messages[index]) {
                  UserMessage m => UserBubble(message: m),
                  AssistantMessage m => AssistantReply(message: m),
                },
              ),
            ),
            const ChatComposer(),
          ],
        ),
      ),
    );
  }
}
