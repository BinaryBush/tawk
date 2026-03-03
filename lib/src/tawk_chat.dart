import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';
import 'tawk_fullscreen_page_stub.dart'
    if (dart.library.html) 'tawk_fullscreen_page_web.dart'
    if (dart.library.io) 'tawk_fullscreen_page_mobile.dart';

/// Controls chat UI: floating widget on web, WebView on mobile.
class TawkController {
  /// Creates controller with chat URL from Tawk.to dashboard.
  TawkController({required this.chatUrl});

  /// The chat URL from your Tawk.to dashboard.
  final String chatUrl;
  bool _isOpen = false;

  /// Opens chat interface.
  Future<void> open(final BuildContext context) async {
    if (kIsWeb) {
      // For web, the embed script normally renders a floating widget.
      // If developers want a page, they can push their own route. The plugin
      // provides no-op or could call JS interop if Tawk_API supports it.
      return;
    }

    if (_isOpen) {
      return;
    }

    _isOpen = true;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (final _) => buildTawkFullScreenPage(chatUrl: chatUrl),
      ),
    );
    _isOpen = false;
  }

  /// Closes chat interface.
  void close(final BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
    }
    _isOpen = false;
  }

  /// Returns true if chat interface is currently open.
  bool isOpen() => _isOpen;

  /// Gets controller from nearest TawkChat ancestor.
  static TawkController of(final BuildContext context) {
    final state = context.findAncestorStateOfType<_TawkChatState>();
    if (state == null) {
      throw FlutterError(
        'No TawkChat found in context. Make sure you placed a TawkChat above'
        ' the calling widget.',
      );
    }
    return state._controller;
  }
}

/// Inherited widget exposing the [TawkController] to descendants.
/// TawkChat exposes its controller via its State.

/// Tawk.to chat integration widget.
///
/// Usage:
/// ```dart
/// TawkChat(
///   chatUrl: 'https://tawk.to/chat/property/widget',
///   child: MyApp(),
/// )
/// ```
class TawkChat extends StatefulWidget {
  /// Creates a TawkChat widget.
  /// Either [chatUrl] or [controller] with matching chatUrl must be provided.
  /// If both are provided, they must have the same chatUrl.
  TawkChat({
    super.key,
    this.chatUrl,
    this.initialHeight,
    this.controller,
    this.child,
  })  : assert(
          chatUrl != null || controller != null,
          'Either chatUrl or controller with chatUrl must be provided',
        ),
        assert(
          chatUrl == null ||
              controller == null ||
              chatUrl == controller.chatUrl,
          'chatUrl must match controller.chatUrl when both are provided',
        );

  /// Chat URL from Tawk.to dashboard (optional if controller is provided).
  /// Must match controller.chatUrl if both are provided.
  final String? chatUrl;

  /// Initial height for web widget placeholder.
  final double? initialHeight;

  /// Pre-configured controller (optional if chatUrl is provided).
  /// Must have matching chatUrl if both are provided.
  final TawkController? controller;

  /// Child widget to wrap.
  final Widget? child;

  @override
  State<TawkChat> createState() => _TawkChatState();
}

class _TawkChatState extends State<TawkChat> {
  late final TawkController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TawkController(chatUrl: widget.chatUrl!);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    if (!kIsWeb) {
      return widget.child ?? const SizedBox.shrink();
    }

    final webHelper = TawkChatWeb(
      chatUrl: _controller.chatUrl,
      initialHeight: widget.initialHeight,
    );

    if (widget.child != null) {
      return Stack(
        children: [
          widget.child!,
          Offstage(child: webHelper),
        ],
      );
    }

    return webHelper;
  }
}
