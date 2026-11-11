import 'package:flutter_test/flutter_test.dart';

import 'package:health_finder/core/theme/theme.dart';

// Temporary test: the counter test was removed together with the counter.
// Screen tests will be added with the screens.
void main() {
  test('theme tokens are defined', () {
    expect(AppGradients.ai.glows, isNotEmpty);
    expect(AppRadius.card, 24);
  });
}
