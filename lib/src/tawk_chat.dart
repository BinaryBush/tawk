import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'tawk_chat_common.dart';
import 'tawk_chat_stub.dart' if (dart.library.html) 'tawk_chat_web.dart';

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
        builder: (final _) => _TawkFullScreenPage(chatUrl: chatUrl),
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

/// Full-screen page used on mobile to show the tawk embed inside a WebView.
class _TawkFullScreenPage extends StatefulWidget {
  const _TawkFullScreenPage({required this.chatUrl});

  final String chatUrl;

  @override
  State<_TawkFullScreenPage> createState() => _TawkFullScreenPageState();
}

class _TawkFullScreenPageState extends State<_TawkFullScreenPage> {
  late final wv.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = wv.WebViewController();
    unawaited(_controller.setJavaScriptMode(wv.JavaScriptMode.unrestricted));
    unawaited(_controller.setBackgroundColor(const Color(0x00000000)));

    // Some embed scripts perform UA sniffing or require a non-empty user
    // agent to run certain features. The plugin sets a conservative, modern
    // UA string to improve compatibility with tawk's embed scripts.
    try {
      unawaited(
        _controller.setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) '
          'Chrome/116.0.0.0 Mobile Safari/537.36',
        ),
      );
    } on Exception catch (_) {
      // setUserAgent may not be available on some platforms/versions; ignore.
    }
    // Set up navigation delegate for handling page lifecycle events
    unawaited(
      _controller.setNavigationDelegate(
        wv.NavigationDelegate(
          onProgress: (final progress) {
            /* Progress: $progress */
          },
          onPageStarted: (final url) {
            /* Page started: $url */
          },
          onPageFinished: (final url) {
            /* Page finished: $url */
          },
          onWebResourceError: (final error) {
            /* Resource error: ${error.description} */
          },
        ),
      ),
    );

    unawaited(_loadTawkHtml());
  }

  Future<void> _loadTawkHtml() async {
    try {
      final pageUrl = Uri.parse(widget.chatUrl);
      await _controller.loadRequest(pageUrl);
      return;
    } on Exception catch (_) {
      try {
        final html = buildTawkEmbedHtml(widget.chatUrl);
        await _controller.loadHtmlString(html);
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tawk Chat'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => TawkController.of(context).close(context),
        ),
      ),
      body: wv.WebViewWidget(controller: _controller),
    );
  }
}
