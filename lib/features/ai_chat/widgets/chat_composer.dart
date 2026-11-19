
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/theme.dart';

/// Message input at the bottom of the chat.
class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    this.enabled = true,
    this.compact = false,
  });

  final ValueChanged<String> onSend;
  final bool enabled;
  final bool compact;

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
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.compact;
    final rowHeight = compact ? 38.0 : 46.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.l,
        compact ? AppSpacing.xs : AppSpacing.m,
        AppSpacing.l,
        compact ? AppSpacing.s : AppSpacing.card,
      ),
      child: ListenableBuilder(
        listenable: _focusNode,
        builder: (context, child) {
          final focused = _focusNode.hasFocus;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              0,
              AppSpacing.xxs,
              0,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(17),
              border: Border.all(color: AppColors.chatBorder),
            ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.s,
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: rowHeight),
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.enter ||
                            event.logicalKey ==
                                LogicalKeyboardKey.numpadEnter)) {
                      if (HardwareKeyboard.instance.isShiftPressed) {
                        return KeyEventResult.ignored;
                      }

                      _submit();
                      return KeyEventResult.handled;
                    }

                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _submit(),
                    textCapitalization: TextCapitalization.sentences,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.body,
                    decoration: InputDecoration(
                      hintText: 'Message HealthFinder...',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.chatPlaceholder,
                      ),
                      filled: false,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: compact ? 8 : 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final canSend =
                    widget.enabled && value.text.trim().isNotEmpty;

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
            child: Icon(
              Icons.arrow_forward,
              size: 20,
              color: AppColors.onAccent,
            ),
          ),
        ),
      ),
    );
  }
}
