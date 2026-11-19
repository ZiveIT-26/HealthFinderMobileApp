
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_controller.dart';

import '../../../core/theme/theme.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_welcome.dart';
import '../widgets/measure_size.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  static const _moveDuration = Duration(milliseconds: 700);
  static const _moveCurve = Curves.easeInOutCubic;

  late final ChatController _chat;
  final _scroll = ScrollController();
  final _backendUrl = dotenv.get("BACKEND_URL");

  double _composerHeight = 0;

  @override
  void initState() {
    super.initState();
    _chat = ChatController(ChatApi(_backendUrl));
    _chat.addListener(_scrollToBottom);
  }

  @override
  void dispose() {
    _chat.removeListener(_scrollToBottom);
    _chat.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _send(String text) => _chat.send(text);

  void _updateComposerHeight(Size size) {
    if ((size.height - _composerHeight).abs() < 0.5) return;

    setState(() => _composerHeight = size.height);
  }

  Widget _buildComposer(bool isLandscape) {
    return MeasureSize(
      onChange: _updateComposerHeight,
      child: ChatComposer(
        enabled: !_chat.loading,
        onSend: _send,
        compact: isLandscape,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        mediaQuery.orientation == Orientation.landscape;
    final isKeyboardVisible = mediaQuery.viewInsets.bottom > 0;

    final animationDuration =
        isKeyboardVisible ? Duration.zero : _moveDuration;

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
                  final isEmpty = _chat.messages.isEmpty;
                  final showWelcome = isEmpty && !isKeyboardVisible;

                  return Stack(
                    children: [
                      Positioned.fill(
                        child: IgnorePointer(
                          ignoring: isEmpty,
                          child: AnimatedOpacity(
                            duration: animationDuration,
                            curve: Curves.easeIn,
                            opacity: isEmpty ? 0 : 1,
                            child: _buildMessageList(),
                          ),
                        ),
                      ),

                      if (showWelcome)
                        Positioned.fill(
                          child: AnimatedAlign(
                            duration: animationDuration,
                            curve: _moveCurve,
                            alignment: Alignment(
                              0,
                              isLandscape ? -0.05 : -0.15,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                children: [
                                  ChatGreeting(
                                    compact: isLandscape,
                                  ),
                                  _buildComposer(isLandscape),
                                  ChatSuggestions(
                                    onSelected: _send,
                                    compact: isLandscape,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Keep the composer outside the message area when
            // a conversation exists or the keyboard is visible.
            ListenableBuilder(
              listenable: _chat,
              builder: (context, _) {
                final isEmpty = _chat.messages.isEmpty;

                if (isEmpty && !isKeyboardVisible) {
                  return const SizedBox.shrink();
                }

                return _buildComposer(isLandscape);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    final messages = _chat.messages;

    return ListView.separated(
      controller: _scroll,
      padding: EdgeInsets.fromLTRB(
        17,
        28,
        17,
        _composerHeight + AppSpacing.l,
      ),
      itemCount: messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemBuilder: (context, index) {
        final message = messages[index];
        final isLast = index == messages.length - 1;

        return message.isUser
            ? UserBubble(text: message.text)
            : AssistantReply(
                text: message.text,
                doctors: message.doctors,
                isStreaming: _chat.loading && isLast,
              );
      },
    );
  }
}
