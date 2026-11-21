import 'package:flutter/material.dart';
import 'package:health_finder/core/widgets/choice_button.dart';

import '../../../core/theme/app_text_styles.dart';

/// "Preferred language" heading + one [ChoiceButton] per supported locale.
class LanguagePicker extends StatelessWidget {
  const LanguagePicker({
    super.key,
    required this.onSelected,
    this.heading = 'Preferred language',
    this.options = defaultOptions,
  });

  final ValueChanged<Locale> onSelected;
  final String heading;
  final List<LanguageOption> options;

  static const defaultOptions = <LanguageOption>[
    LanguageOption(label: 'English', locale: Locale('en')),
    LanguageOption(label: 'Slovenčina', locale: Locale('sk')),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: AppTextStyles.caption,
        ),
        const SizedBox(height: 9), // heading box 32px -> buttons start at 41px
        for (var i = 0; i < options.length; i++) ...[
          if (i > 0) const SizedBox(height: 12),
          ChoiceButton(
            label: options[i].label,
            onPressed: () => onSelected(options[i].locale),
          ),
        ],
      ],
    );
  }
}

class LanguageOption {
  const LanguageOption({required this.label, required this.locale});

  /// Shown in the language's own name, so it is never translated.
  final String label;
  final Locale locale;
}