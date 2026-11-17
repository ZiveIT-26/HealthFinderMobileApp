import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// Message input at the bottom of the chat.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    this.enabled = true,
  });

  /// Called with the trimmed message text when the user taps send.
  final ValueChanged<String> onSend;

  /// Set to false while waiting for a response, for example.
  final bool enabled;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;

    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus(); // keep the keyboard open
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.card),
      child: Container(
        constraints: const BoxConstraints(minHeight: 46),
        padding: const EdgeInsets.fromLTRB(AppSpacing.m, 2, AppSpacing.xxs, 2),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(17),
          border: Border.all(color: AppColors.chatBorder),
        ),
        child: Row(
          // Keeps the send button at the bottom when the text grows to multiple lines
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: widget.enabled,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                style: AppTextStyles.body,
                decoration: InputDecoration(
                  hintText: 'Message HealthFinder...',
                  hintStyle: AppTextStyles.body.copyWith(color: AppColors.chatPlaceholder),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              // Rebuilds only the button when the text changes, not the whole composer
              child: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, _) {
                  final canSend = widget.enabled && value.text.trim().isNotEmpty;
                  return _SendButton(onTap: canSend ? _submit : null);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = onTap != null;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: isActive ? 1 : 0.4,
      child: Material(
        color: AppColors.chatAccent,
        borderRadius: BorderRadius.circular(13),
        child: InkWell(
          borderRadius: BorderRadius.circular(13),
          onTap: onTap,
          child: const SizedBox(
            width: 38,
            height: 38,
            child: Icon(Icons.arrow_forward, size: 20, color: AppColors.onAccent),
          ),
        ),
      ),
    );
  }
}