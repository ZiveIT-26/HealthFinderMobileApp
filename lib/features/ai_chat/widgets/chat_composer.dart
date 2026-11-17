import 'package:flutter/material.dart';

import '../../../core/theme/theme.dart';

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

  static const _rowHeight = 46.0; // height of a one-line composer

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, AppSpacing.card),
      child: ListenableBuilder(
        listenable: _focusNode,
        builder: (context, child) {
          final focused = _focusNode.hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.fromLTRB(AppSpacing.m, 0, AppSpacing.xxs, 0),
            // Base 1px border, always there. Takes no extra space when focused.
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: AppColors.chatBorder),
            ),
            // Focus ring painted on top, so changing its width never shifts the layout.
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              border: Border.all(
                width: 2,
                color: focused
                    ? AppColors.chatAccent
                    : AppColors.chatAccent.withValues(alpha: 0),
              ),
            ),
            child: child,
          );
        },
        child: Row(
          // Centers the send button against the whole field, including multi-line text
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _rowHeight),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText: 'Message HealthFinder...',
                    hintStyle: AppTextStyles.body.copyWith(color: AppColors.chatPlaceholder),
                    filled: false,
                    // Every state is set explicitly, so the theme can't add a focus border.
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final canSend = widget.enabled && value.text.trim().isNotEmpty;
                return _SendButton(onTap: canSend ? _submit : null);
              },
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