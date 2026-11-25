import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../theme/theme.dart';
import 'placeholder_text.dart';

/// Text input of a form row. Right aligned and borderless next to a label;
/// left aligned in a soft field box under a label (`InfoRow.field`).
/// Multi-line when [maxLines] is null.
class InlineTextField extends StatefulWidget {
  const InlineTextField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Not set',
    this.textAlign = TextAlign.right,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.suffix,
    this.prefill,
  });

  /// Phone number field that starts with the Slovak code.
  const InlineTextField.phone({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Not set',
    this.textAlign = TextAlign.right,
  })  : maxLines = 1,
        keyboardType = TextInputType.phone,
        inputFormatters = null,
        suffix = null,
        prefill = '+421 ';

  final TextEditingController controller;

  /// Gets the trimmed text, or null when it is empty or only [prefill].
  final ValueChanged<String?> onChanged;
  final String hint;
  final TextAlign textAlign;
  final int? maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  /// Unit after the text: "cm", "kg".
  final String? suffix;

  /// Put into an empty field when it gets focus, removed again if nothing
  /// was typed after it.
  final String? prefill;

  @override
  State<InlineTextField> createState() => _InlineTextFieldState();
}

class _InlineTextFieldState extends State<InlineTextField> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {}); // Focus outline of the field box.
    final prefill = widget.prefill;
    if (prefill == null) return;
    final controller = widget.controller;
    if (_focus.hasFocus && controller.text.isEmpty) {
      controller.value = TextEditingValue(
        text: prefill,
        selection: TextSelection.collapsed(offset: prefill.length),
      );
    } else if (!_focus.hasFocus && controller.text.trim() == prefill.trim()) {
      controller.clear();
    }
  }

  void _onChanged(String text) {
    final value = text.trim();
    final empty = value.isEmpty || value == widget.prefill?.trim();
    widget.onChanged(empty ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    final alignedRight = widget.textAlign == TextAlign.right;
    final field = TextField(
      controller: widget.controller,
      focusNode: _focus,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      style: alignedRight
          ? AppTextStyles.detailRowValue
          : AppTextStyles.body.copyWith(color: AppColors.ink),
      decoration: InputDecoration.collapsed(
        hintText: widget.hint,
        hintStyle: PlaceholderText.style,
      ).copyWith(
        filled: false,
        suffixText: widget.suffix,
        suffixStyle: PlaceholderText.style,
        // The app theme gives fields an outline on focus; here the box
        // around the field shows the focus instead.
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onChanged: _onChanged,
    );
    if (alignedRight) return field;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: 11),
      decoration: BoxDecoration(
        color: AppColors.colorSoft,
        borderRadius: BorderRadius.circular(AppRadius.field),
        border: Border.all(
          color: _focus.hasFocus ? AppColors.colorBrand : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: field,
    );
  }
}
