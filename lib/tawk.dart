/// Modern Flutter plugin for Tawk.to live chat integration.
///
/// Provides cross-platform support with efficient DOM injection on web
/// and native WebView integration on mobile/desktop platforms.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:tawk/tawk.dart';
///
/// // Create controller
/// final controller = TawkController(
///   chatUrl: 'https://tawk.to/chat/YOUR_PROPERTY_ID/YOUR_WIDGET_ID',
/// );
///
/// // Wrap your app
/// TawkChat(
///   controller: controller,
///   child: MyApp(),
/// )
///
/// // Open chat from anywhere
/// TawkController.of(context).open(context);
/// ```
///
/// See README.md for complete setup instructions and examples.
library;

export 'src/tawk_chat.dart' show TawkChat, TawkController;
