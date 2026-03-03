// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tawk_example/main.dart';
import 'package:tawk/tawk.dart';

void main() {
  testWidgets('Open Tawk Chat button present', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final controller = TawkController(
      chatUrl: 'https://tawk.to/chat/<id>/<widget>',
    );
    await tester.pumpWidget(ExampleApp(tawkController: controller));

    // Verify that the button to open the chat exists.
    expect(find.text('Open Tawk Chat'), findsOneWidget);
  });
}
