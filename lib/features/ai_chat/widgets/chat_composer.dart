import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.hintText = 'Message HealthFinder...',
    this.listeningHintText = 'Listening...',
    this.minLines = 1,
    this.maxLines = 5,
    this.leading,
    this.onVoiceTap,
    this.isListening = false,
    this.padding = const EdgeInsets.fromLTRB(
      AppSpacing.l,
      AppSpacing.m,
      AppSpacing.l,
      AppSpacing.card,
    ),
  });

  final ValueChanged<String> onSend;

  /// Optional external controller. Pass one when the parent needs to read or
  /// change the text (for example, to insert speech recognition results).
  /// If omitted, the composer creates and disposes its own.
  /// Don't swap it for another one after the first build.
  final TextEditingController? controller;

  final FocusNode? focusNode;

  /// Set to false while waiting for a response, for example.
  final bool enabled;

  final String hintText;

  /// Hint shown while [isListening] is true.
  final String listeningHintText;

  final int minLines;
  final int maxLines;

  final Widget? leading;

  final VoidCallback? onVoiceTap;

  final bool isListening;

  final EdgeInsetsGeometry padding;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  static const _rowHeight = 46.0;
  static const _fieldRadius = 17.0;

  late final bool _ownsController = widget.controller == null;
  late final bool _ownsFocusNode = widget.focusNode == null;
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty || !widget.enabled) return;

    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus(); // keep the keyboard open
  }

  /// Voice button, stop button or send button, depending on the state.
  Widget _buildAction(TextEditingValue value) {
    final hasText = value.text.trim().isNotEmpty;
    final hasVoice = widget.onVoiceTap != null;
    final showVoice = hasVoice && (widget.isListening || !hasText);

    if (showVoice) {
      return _ActionButton(
        key: const ValueKey('voice'),
        icon: widget.isListening ? Icons.stop_rounded : Icons.mic_none_rounded,
        tooltip: widget.isListening ? 'Stop recording' : 'Voice input',
        filled: !widget.isListening,
        onTap: widget.enabled ? widget.onVoiceTap : null,
      );
    }

    return _ActionButton(
      key: const ValueKey('send'),
      icon: Icons.arrow_forward,
      tooltip: 'Send',
      onTap: widget.enabled && hasText ? _submit : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
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
              borderRadius: BorderRadius.circular(_fieldRadius),
              border: Border.all(color: AppColors.chatBorder),
            ),
            // Focus ring painted on top, so changing its width never shifts the layout.
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_fieldRadius),
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
          // Centers the action button against the whole field, including multi-line text
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: AppSpacing.s,
          children: [
            if (widget.leading != null) widget.leading!,
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: _rowHeight),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  minLines: widget.minLines,
                  maxLines: widget.maxLines,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  textAlignVertical: TextAlignVertical.center,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                    hintText:
                        widget.isListening ? widget.listeningHintText : widget.hintText,
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
              builder: (context, value, _) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _buildAction(value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Square icon button on the right side of the composer.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.filled = true,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  /// Accent background with a light icon. When false: soft background with an
  /// accent icon (used for the "recording" state).
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(13);
    final background =
        filled ? AppColors.chatAccent : AppColors.chatAccent.withValues(alpha: 0.12);
    final foreground = filled ? AppColors.onAccent : AppColors.chatAccent;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: onTap != null ? 1 : 0.4,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: background,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            onTap: onTap,
            child: SizedBox.square(
              dimension: 38,
              child: Icon(icon, size: 20, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}