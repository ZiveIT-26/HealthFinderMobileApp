import 'package:health_finder/features/ai_chat/widgets/chat_suggestions.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:health_finder/core/auth/auth_controller.dart';
import 'package:health_finder/core/network/chat_api.dart';
import 'package:health_finder/core/network/chat_controller.dart';
import 'package:health_finder/features/ai_chat/widgets/voice_input_contoller.dart';

import '../../../core/theme/theme.dart';
import '../widgets/chat_composer.dart';
import '../widgets/chat_header.dart';
import '../widgets/chat_messages.dart';
import '../widgets/chat_welcome.dart';

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

  /// Text field of the composer. The screen owns it so that voice input can
  /// write into it.
  final _text = TextEditingController(); // new

  /// Dictation with the phone's built-in speech recognition.
  final _voice = VoiceInputController(
    // localeId: 'en_US', // set it if the app isn't English-only
    // onDeviceOnly: true, // keep audio on the phone (see notes in chat)
  ); // new

  /// Height of the bottom block, so the message list can end above it.
  double _bottomBlockHeight = 0;

  @override
  void initState() {
    super.initState();
    _chat = ChatController(
      ChatApi(_backendUrl, clientFactory: authController.createClient),
    );
    _chat.addListener(_scrollToBottom);
  }

  @override
  void dispose() {
    _chat.removeListener(_scrollToBottom);
    _chat.dispose();
    _voice.dispose(); // new
    _text.dispose(); // new
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

  void _send(String text) {
    // A suggestion chip can be tapped while recording.
    if (_voice.isListening) _voice.stop(); // new
    _chat.send(text);
  }

  void _newChat() {
    if (_voice.isListening) _voice.stop(); // new
    _chat.clear();
  }

  Future<void> _onVoiceTap() async {
    final ok = await _voice.toggle(_text);
    if (ok || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voice input is not available. '
          'Check microphone and speech recognition permissions in Settings.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.white,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            ListenableBuilder(
              listenable: _chat,
              builder: (context, _) => ChatHeader(
                onNewChat: _chat.messages.isEmpty || _chat.loading ? null : _newChat,
                onHistory: () {}, // TODO: open chats history
              ),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _chat,
                builder: (context, _) {
                  final isEmpty = _chat.messages.isEmpty;

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: isEmpty
                        ? _buildWelcome()
                        : KeyedSubtree(
                            key: const ValueKey('messages'),
                            child: _buildMessageList(),
                          ),
                  );
                },
              ),
            ),
            // Pinned to the bottom. Rebuilds on chat state and on voice state.
            ListenableBuilder(
              listenable: Listenable.merge([_chat, _voice]),
              builder: (context, _) => ChatComposer(
                controller: _text,
                enabled: !_chat.loading,
                onSend: _send,
                onVoiceTap: _onVoiceTap,
                isListening: _voice.isListening,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Greeting card + "Try asking" chips. Scrolls if the keyboard shrinks the space.
  Widget _buildWelcome() {
    return SingleChildScrollView(
      key: const ValueKey('welcome'),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ChatGreeting(),
          ChatSuggestions(onSelected: _send),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
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
                isStreaming: _chat.loading && isLast,
              );
      },
    );
  }
}