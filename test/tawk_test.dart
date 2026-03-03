import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tawk/src/tawk_chat_common.dart';
import 'package:tawk/tawk.dart';

void main() {
  group('TawkController', () {
    test('should create controller with chatUrl', () {
      const testUrl = 'https://tawk.to/chat/test/test';
      final controller = TawkController(chatUrl: testUrl);
      expect(controller.chatUrl, testUrl);
    });

    test('should report closed state initially', () {
      final controller = TawkController(
        chatUrl: 'https://tawk.to/chat/test/test',
      );
      expect(controller.isOpen(), false);
    });
  });

  group('TawkChat Widget', () {
    testWidgets('should create with chatUrl',
        (final WidgetTester tester) async {
      const testUrl = 'https://tawk.to/chat/test/test';

      await tester.pumpWidget(
        MaterialApp(
          home: TawkChat(chatUrl: testUrl, child: const Text('Test')),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('should create with controller',
        (final WidgetTester tester) async {
      final controller = TawkController(
        chatUrl: 'https://tawk.to/chat/test/test',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: TawkChat(controller: controller, child: const Text('Test')),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });

  group('URL Parsing', () {
    test('should parse valid Tawk.to URLs correctly', () {
      const testUrl =
          'https://tawk.to/chat/70alkkcd0026a6f19a192939/1ajf5ggchc5yk00';

      final propertyId = getPropertyId(testUrl);
      final widgetId = getWidgetId(testUrl);
      final embedSrc = getEmbedScriptSrc(testUrl);

      expect(propertyId, '70alkkcd0026a6f19a192939');
      expect(widgetId, '1ajf5ggchc5yk00');
      expect(
        embedSrc,
        'https://embed.tawk.to/70alkkcd0026a6f19a192939/1ajf5ggchc5yk00',
      );
    });

    test('should handle invalid URLs gracefully', () {
      const invalidUrl = 'https://example.com/invalid';

      final propertyId = getPropertyId(invalidUrl);
      final widgetId = getWidgetId(invalidUrl);
      final embedSrc = getEmbedScriptSrc(invalidUrl);

      expect(propertyId, isNull);
      expect(widgetId, isNull);
      expect(embedSrc, isNull);
    });

    test('should generate script content correctly', () {
      const embedSrc = 'https://embed.tawk.to/test/widget';
      final scriptContent = getTawkScriptContent(embedSrc);

      expect(scriptContent, contains('Tawk_API'));
      expect(scriptContent, contains('Tawk_LoadStart'));
      expect(scriptContent, contains(embedSrc));
      expect(scriptContent, contains('document.createElement("script")'));
    });
  });
}
