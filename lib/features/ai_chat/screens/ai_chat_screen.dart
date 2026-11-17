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

  /// Height of the bottom block, so the message list can end above it.
  double _bottomBlockHeight = 0;

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

  /// Runs on every notifyListeners(), so the view follows streaming tokens.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  void _send(String text) => _chat.send(text);

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
                  final isEmpty = _chat.messages.isEmpty;

                  return Stack(
                    children: [
                      // Messages fade in as the composer leaves the center.
                      Positioned.fill(
                        child: IgnorePointer(
                          ignoring: isEmpty,
                          child: AnimatedOpacity(
                            duration: _moveDuration,
                            curve: Curves.easeIn,
                            opacity: isEmpty ? 0 : 1,
                            child: _buildMessageList(),
                          ),
                        ),
                      ),
                      // One block: greeting, composer, suggestions.
                      AnimatedAlign(
                        duration: _moveDuration,
                        curve: _moveCurve,
                        alignment: isEmpty
                            ? const Alignment(0, -0.15)
                            : Alignment.bottomCenter,
                        child: MeasureSize(
                          onChange: (size) {
                            if (size.height == _bottomBlockHeight) return;
                            setState(() => _bottomBlockHeight = size.height);
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _Collapsible(
                                visible: isEmpty,
                                duration: _moveDuration,
                                curve: _moveCurve,
                                child: const ChatGreeting(),
                              ),
                              ChatComposer(
                                enabled: !_chat.loading,
                                onSend: _send,
                              ),
                              _Collapsible(
                                visible: isEmpty,
                                duration: _moveDuration,
                                curve: _moveCurve,
                                child: ChatSuggestions(onSelected: _send),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
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
      // Bottom padding = the composer block, so the last message isn't covered.
      padding: EdgeInsets.fromLTRB(17, 28, 17, _bottomBlockHeight + AppSpacing.l),
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
                isStreaming: _chat.loading && isLast,
              );
      },
    );
  }
}

/// Fades and collapses its child to zero height when not visible.
class _Collapsible extends StatelessWidget {
  const _Collapsible({
    required this.visible,
    required this.child,
    required this.duration,
    required this.curve,
  });

  final bool visible;
  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      sizeCurve: curve,
      crossFadeState: visible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstChild: child,
      secondChild: const SizedBox(width: double.infinity),
    );
  }
}