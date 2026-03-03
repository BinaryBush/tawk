import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart' as wv;

import 'tawk_chat.dart';
import 'tawk_chat_common.dart';

/// Builds a full-screen WebView page for mobile platforms.
Widget buildTawkFullScreenPage({required final String chatUrl}) {
  return _TawkFullScreenPage(chatUrl: chatUrl);
}

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

    try {
      unawaited(
        _controller.setUserAgent(
          'Mozilla/5.0 (Linux; Android 10; Mobile) AppleWebKit/537.36 (KHTML, like Gecko) '
          'Chrome/116.0.0.0 Mobile Safari/537.36',
        ),
      );
    } on Exception catch (_) {}

    unawaited(
      _controller.setNavigationDelegate(
        wv.NavigationDelegate(
          onProgress: (final progress) {},
          onPageStarted: (final url) {},
          onPageFinished: (final url) {},
          onWebResourceError: (final error) {},
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
      final html = buildTawkEmbedHtml(widget.chatUrl);
      await _controller.loadHtmlString(html);
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
