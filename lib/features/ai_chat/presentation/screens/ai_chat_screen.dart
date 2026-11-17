import 'package:flutter/material.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_controller.dart';

import '../../../../core/theme/theme.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  late final ChatController _chat;
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    _chat = ChatController(ChatApi("http://10.0.2.2:3000")); // or inject via Provider / get_it
    _chat.addListener(_scrollToBottom);
  }

  @override
  void dispose() {
    _chat.removeListener(_scrollToBottom);
    _chat.dispose(); // also cancels the stream subscription
    _scroll.dispose();
    super.dispose();
  }

  /// Runs on every notifyListeners(), so the view follows streaming tokens.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surface,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const ChatHeader(),
            Expanded(
              child: ListenableBuilder(
                listenable: _chat,
                builder: (context, _) {
                  final messages = _chat.messages;
                  return ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(17, 28, 17, AppSpacing.l),
                    itemCount: messages.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final m = messages[index];
                      final isLast = index == messages.length - 1;

                      return m.isUser
                          ? UserBubble(text: m.text)
                          : AssistantReply(
                              text: m.text,
                              doctors: m.doctors,
                              // show a typing indicator until the first token arrives
                              isStreaming: _chat.loading && isLast,
                            );
                    },
                  );
                },
              ),
            ),
            ListenableBuilder(
              listenable: _chat,
              builder: (context, _) => ChatComposer(
                enabled: !_chat.loading,
                onSend: (text) => _chat.send(text),
              ),
            ),
          ],
        ),
      ),
    );
  }
}