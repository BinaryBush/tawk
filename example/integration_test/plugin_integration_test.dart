// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tawk/tawk.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Tawk Integration Tests', () {
    testWidgets('TawkChat widget integration test', (
      WidgetTester tester,
    ) async {
      const testChatUrl = 'https://tawk.to/chat/test-property/test-widget';
      final controller = TawkController(chatUrl: testChatUrl);

      await tester.pumpWidget(
        MaterialApp(
          home: TawkChat(
            controller: controller,
            child: Scaffold(
              appBar: AppBar(title: const Text('Tawk Test')),
              body: Builder(
                builder: (context) => Center(
                  child: ElevatedButton(
                    onPressed: () => TawkController.of(context).open(context),
                    child: const Text('Open Chat'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the widget tree is built correctly
      expect(find.text('Tawk Test'), findsOneWidget);
      expect(find.text('Open Chat'), findsOneWidget);

      // Verify controller can be accessed
      expect(controller.chatUrl, testChatUrl);
      expect(controller.isOpen(), false);
    });
  });
}
