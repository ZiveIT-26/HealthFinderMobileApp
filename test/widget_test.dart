import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:health_finder/core/widgets/fit_to_screen.dart';
import 'package:health_finder/core/theme/theme.dart';

// Temporary test: the counter test was removed together with the counter.
// Screen tests will be added with the screens.
void main() {
  testWidgets('FitToScreen handles zero-sized constraints', (tester) async {
    await tester.binding.setSurfaceSize(Size.zero);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: FitToScreen(
          designSize: Size(430, 850),
          child: const SizedBox.expand(),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(FitToScreen),
        matching: find.byType(FittedBox),
      ),
      findsNothing,
    );
  });

  test('theme tokens are defined', () {
    expect(AppGradients.ai.glows, isNotEmpty);
    expect(AppRadius.card, 24);
  });
}
