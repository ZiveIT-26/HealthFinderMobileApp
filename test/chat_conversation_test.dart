import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_finder/core/network/chat_controller.dart';
import 'package:health_finder/features/ai_chat/widgets/chat_conversation.dart';

void main() {
  testWidgets('scroll-to-latest button appears when away from bottom', (
    tester,
  ) async {
    final messages = List.generate(
      24,
      (index) => Message(isUser: true, text: 'Message $index'),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChatConversation(
            messages: messages,
            sessionId: null,
            isLoading: false,
            homeLabel: null,
            onCurrentLocation: (_) {},
            onHomeLocation: (_) {},
            onSetHome: (_) {},
            onDeclineLocation: (_) {},
            onRememberChanged: (_, _) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('Scroll to latest'), findsNothing);
    await tester.drag(find.byType(ListView), const Offset(0, 500));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Scroll to latest'), findsOneWidget);

    await tester.tap(find.byTooltip('Scroll to latest'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Scroll to latest'), findsNothing);
  });
}
