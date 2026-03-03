import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'tawk_chat_common.dart';

@JS()
@staticInterop

/// DOM document interface for script injection.
class Document {}

/// DOM document interface for script injection.
extension DocumentExtensions on Document {
  /// Accesses the document head element.
  external Element? get head;

  /// Accesses the document body element.
  external Element? get body;

  /// Finds an element by ID.
  external Element? getElementById(final String id);

  /// Creates a new element by tag name.
  external Element createElement(final String tag);
}

@JS()
@staticInterop

/// DOM element interface for script manipulation.
class Element {}

/// DOM element interface for script manipulation.
extension ElementExtensions on Element {
  /// Sets the element ID.
  external set id(final String id);

  /// Gets the element ID.
  external String get id;

  /// Appends a child element.
  external Element appendChild(final Element child);

  /// Removes a child element.
  external Element removeChild(final Element child);

  /// Sets an attribute on the element.
  external void setAttribute(final String name, final String value);

  /// Sets the text content of the element.
  external set textContent(final String content);
}

@JS('document')
external Document? get _document;

/// Web chat widget that injects Tawk.to script.
class TawkChatWeb extends StatefulWidget {
  /// Creates a TawkChatWeb instance.
  const TawkChatWeb({super.key, required this.chatUrl, this.initialHeight});

  /// Chat URL from Tawk.to dashboard.
  final String chatUrl;

  /// Placeholder height (null = expand).
  final double? initialHeight;

  @override
  State<TawkChatWeb> createState() => _TawkChatWebState();
}

class _TawkChatWebState extends State<TawkChatWeb> {
  String? _containerId;

  Document get document => _document!;

  @override
  void initState() {
    super.initState();
    _attachTawk();
  }

  @override
  void dispose() {
    if (_containerId != null) {
      final existing = document.getElementById(_containerId!);
      if (existing != null) {
        document.body!.removeChild(existing);
      }
    }
    super.dispose();
  }

  void _attachTawk() {
    final id = 'tawk-${widget.chatUrl.hashCode}';
    _containerId = id;

    // Remove any existing instance
    final existing = document.getElementById(id);

    if (existing != null) {
      try {
        document.body!.removeChild(existing);
      } on Exception catch (_) {
        // Element might have been removed already, ignore
      }
    }

    final embedSrc = getEmbedScriptSrc(widget.chatUrl);

    if (embedSrc == null) {
      // Fallback: create iframe with the chat URL directly
      final div = document.createElement('div')..id = id;
      final iframe = document.createElement('iframe');
      final html = buildIframeHtml(widget.chatUrl);

      iframe
        ..setAttribute('srcdoc', html)
        ..setAttribute('style', 'width:100%;height:100%;border:0;');

      div.appendChild(iframe);
      document.body!.appendChild(div);
      return;
    }

    // Inject the script directly into the head (standard Tawk approach)
    final script = document.createElement('script')
      ..setAttribute('type', 'text/javascript');

    try {
      script.textContent = getTawkScriptContent(embedSrc);
      document.head!.appendChild(script);
    } on Exception catch (_) {
      // Fallback to separate script elements
      final init = document.createElement('script')
        ..setAttribute('type', 'text/javascript')
        ..textContent = 'var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();';

      final loader = document.createElement('script')
        ..setAttribute('src', embedSrc)
        ..setAttribute('async', 'true')
        ..setAttribute('type', 'text/javascript')
        ..setAttribute('crossorigin', '*');

      document.head!.appendChild(init);
      document.head!.appendChild(loader);
    }

    // Create a marker div for cleanup
    final div = document.createElement('div')
      ..id = id
      ..setAttribute('style', 'display:none;');

    document.body!.appendChild(div);
  }

  @override
  Widget build(final BuildContext context) {
    final height = widget.initialHeight;
    const placeholder = ColoredBox(
      color: Colors.transparent,
      child: Center(child: Text('Tawk chat (web)')),
    );
    return SizedBox(height: height, child: placeholder);
  }
}
