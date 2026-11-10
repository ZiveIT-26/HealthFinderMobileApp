import 'package:flutter_test/flutter_test.dart';

import 'package:health_finder/core/theme/theme.dart';

// Тимчасовий тест: старий тест лічильника видалено разом із лічильником.
// Тести екранів додамо, коли з'являться екрани.
void main() {
  test('theme tokens are defined', () {
    expect(AppGradients.ai.glows, isNotEmpty);
    expect(AppRadius.card, 24);
  });
}
