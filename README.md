# tawk

[![pub package](https://img.shields.io/pub/v/tawk.svg)](https://pub.dev/packages/tawk)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![CI](https://github.com/csertant/tawk/actions/workflows/test.yaml/badge.svg)](https://github.com/csertant/tawk/actions)

A small Flutter plugin that embeds the tawk.to chat widget. Works on web (DOM injection) and on mobile/desktop using a WebView.

## Quick Example

```dart
import 'package:flutter/material.dart';
import 'package:tawk/tawk.dart';

void main() {
  // Create a single controller with your Tawk.to chat URL
  final tawkController = TawkController(
    chatUrl: 'https://tawk.to/chat/YOUR_PROPERTY_ID/YOUR_WIDGET_ID',
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
      // Place TawkChat at the app root using MaterialApp.builder
      // This ensures the controller is available throughout the app
      builder: (context, child) {
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
    // Access the controller from anywhere in the app
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
```

## Installation

### Add dependency

```yaml
dependencies:
  tawk: ^0.1.0
```

Or run:
```bash
flutter pub add tawk
```

### Get your Tawk.to chat URL

1. Sign up at [tawk.to](https://www.tawk.to/) and create a property
2. Go to **Administration** → **Chat Widget**
3. Copy your chat URL (format: `https://tawk.to/chat/PROPERTY_ID/WIDGET_ID`)

### Import and use

```dart
import 'package:tawk/tawk.dart';
```

## Usage

### Recommended Pattern

1. **Create a controller** with your Tawk.to chat URL
2. **Place TawkChat at app root** using `MaterialApp.builder`
3. **Open chat programmatically** from anywhere using `controller.open(context)`

See the Example app code above for a complete implementation.

### Alternative Usage Patterns

#### Direct URL (creates controller internally)
```dart
TawkChat(
  chatUrl: 'https://tawk.to/chat/YOUR_PROPERTY_ID/YOUR_WIDGET_ID',
  child: MyApp(),
)
```

#### Manual controller with Stack
```dart
Stack(
  children: [
    MyApp(),
    TawkChat(controller: tawkController),
  ],
)
```

## Platform Behavior

### 🌐 Web
- Injects the official Tawk.to embed script into the document head
- Renders the standard floating chat widget (bottom-right corner)
- Uses `dart:js_interop` for efficient DOM manipulation
- Supports both embedded and standalone modes

### 📱 Mobile/Desktop
- Opens full-screen WebView with Tawk.to chat interface
- Uses `webview_flutter` for native platform integration
- Automatic fallback to iframe if direct URL loading fails
- Optimized WebView settings for chat functionality

## Features

- **Cross-platform**: Web, iOS, Android
- **Optimized performance**: Simple URL parsing, efficient DOM injection, lightweight widget
- **Flexible API**: Controller-based or direct URL usage
- **Security-focused**: Minimal permissions, secure iframe attributes
- **Modern Dart**: Uses latest language features and best practices

## API Reference

### TawkController

```dart
// Create controller
final controller = TawkController(chatUrl: 'https://tawk.to/chat/...');

// Open chat (mobile: opens WebView, web: activates existing widget)
await controller.open(context);

// Close chat (mobile only, closes WebView)
controller.close(context);

// Check if chat is currently open
final isOpen = await controller.isOpen();

// Access controller from widget tree
final controller = TawkController.of(context);
```

### TawkChat Widget

```dart
// With controller (recommended)
TawkChat(
  controller: controller,
  child: MyApp(), // optional
)

// Direct URL (creates internal controller)
TawkChat(
  chatUrl: 'https://tawk.to/chat/...',
  initialHeight: 400, // web only, optional
  child: MyApp(), // optional
)
```

## Troubleshooting

### Chat not appearing on web
- Verify your chat URL format: `https://tawk.to/chat/PROPERTY_ID/WIDGET_ID`
- Check browser console for script loading errors
- Ensure TawkChat widget is in the widget tree

### Android predictive back navigation issues
- Add `android:enableOnBackInvokedCallback="true"` to your AndroidManifest.xml

### WebView issues on mobile
- Ensure INTERNET permission is declared in AndroidManifest.xml
- Check that the chat URL is accessible from mobile browsers

## Privacy & Legal

⚠️ **Important**: This package integrates with the third-party Tawk.to service. You must:
- Provide your own Tawk.to chat URL and account
- Comply with Tawk.to's terms of service
- Follow applicable privacy laws (GDPR, CCPA, etc.)
- Update your privacy policy to mention Tawk.to integration

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a new branch
3. Add tests for new functionality
4. Pass all CI checks
5. Submit a pull request

## Metadata
:green_book: [Documentation](https://pub.dev/documentation/tawk/latest/)

:email: [contact@binarybush.dev](mailto:contact@binarybush.dev)

:bug: [Bug report](https://github.com/BinaryBush/tawk/issues/new?assignees=&labels=bug%2Ctriage&template=1_bug.yaml)

:zap: [Requesting features](https://github.com/BinaryBush/tawk/issues/new?assignees=&labels=new-feature&template=2_feature_request.yaml)

:page_with_curl: [License](LICENSE)

Every opened issue is very much appreciated!
