import 'package:material_ui/material_ui.dart';

import '../../../core/theme/theme.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSend,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.hintText = 'Type your health question...',
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
  static const _rowHeight = 52.0;
  static const _fieldRadius = 14.0;

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
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              0,
              AppSpacing.xs,
              0,
            ),
            decoration: BoxDecoration(
              color: AppColors.purpleSoft,
              borderRadius: BorderRadius.circular(_fieldRadius),
            ),
            // Focus ring painted on top, so it never shifts the layout.
            foregroundDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_fieldRadius),
              border: Border.all(
                width: 2,
                color: focused
                    ? AppColors.actionPurple
                    : AppColors.actionPurple.withValues(alpha: 0),
              ),
            ),
            child: child,
          );
        },
        child: Row(
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
                  cursorColor: AppColors.actionPurple,
                  style: AppTextStyles.body.copyWith(color: AppColors.ink),
                  decoration: InputDecoration(
                    hintText: widget.isListening
                        ? widget.listeningHintText
                        : widget.hintText,
                    hintStyle: AppTextStyles.body.copyWith(
                      color: AppColors.secondaryText.withValues(alpha: 0.75),
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),
            // Send button (always visible, enabled only when there is text).
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (context, value, _) {
                final hasText = value.text.trim().isNotEmpty;
                return _ActionButton(
                  icon: Icons.arrow_forward,
                  tooltip: 'Send',
                  style: _ActionStyle.primary,
                  onTap: widget.enabled && hasText ? _submit : null,
                );
              },
            ),
            // Voice button (white; solid purple with stop icon while recording).
            if (widget.onVoiceTap != null)
              _ActionButton(
                icon: widget.isListening
                    ? Icons.stop_rounded
                    : Icons.mic_none_rounded,
                tooltip: widget.isListening ? 'Stop recording' : 'Voice input',
                style: widget.isListening
                    ? _ActionStyle.primary
                    : _ActionStyle.secondary,
                onTap: widget.enabled ? widget.onVoiceTap : null,
              ),
          ],
        ),
      ),
    );
  }
}

enum _ActionStyle { primary, secondary }

/// Square icon button on the right side of the composer.
class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    required this.style,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;
  final _ActionStyle style;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    final isPrimary = style == _ActionStyle.primary;
    final background = isPrimary ? AppColors.actionPurple : AppColors.white;
    final foreground =
        isPrimary ? AppColors.textOnAction : AppColors.actionPurple;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: onTap != null ? 1 : 0.5,
      child: Tooltip(
        message: tooltip,
        child: Material(
          color: background,
          borderRadius: radius,
          child: InkWell(
            borderRadius: radius,
            splashColor: isPrimary
                ? AppColors.actionPurplePressed
                : AppColors.purpleSoft,
            onTap: onTap,
            child: SizedBox.square(
              dimension: 40,
              child: Icon(icon, size: 20, color: foreground),
            ),
          ),
        ),
      ),
    );
  }
}