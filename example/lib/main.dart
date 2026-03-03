import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

void main() {
  // Create a single controller and pass it into the app so it's available
  // globally and the TawkChat widget doesn't need a duplicate chatUrl.
  final tawkController = TawkController(
    chatUrl: 'https://tawk.to/chat/<property_id>/<widget>',
  );
  runApp(ExampleApp(tawkController: tawkController));
}

class ExampleApp extends StatelessWidget {
  final TawkController tawkController;
  const ExampleApp({required this.tawkController, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tawk Example',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Inject the TawkChat via the builder so it wraps the Navigator and
      // all routes. This ensures TawkController.of(context) works anywhere.
      builder: (context, child) {
        // Place TawkChat above the navigator by passing the navigator `child`
        // as TawkChat's child. This makes TawkChat an ancestor of all routes
        // and allows `TawkController.of(context)` to find the controller.
        return TawkChat(
          controller: tawkController,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TawkController.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tawk Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => controller.open(context),
          child: const Text('Open Tawk Chat'),
        ),
      ),
    );
  }
}
