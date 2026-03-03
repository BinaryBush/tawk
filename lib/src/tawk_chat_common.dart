// Shared helpers for building tawk embed script URLs and HTML.
import 'package:flutter/foundation.dart';

/// Converts chat URL to embed script URL, or null if invalid.
String? getEmbedScriptSrc(final String chatUrl) {
  final prop = getPropertyId(chatUrl);
  final wid = getWidgetId(chatUrl);
  if (prop == null || wid == null) {
    return null;
  }
  return 'https://embed.tawk.to/$prop/$wid';
}

/// Parses chat URL and returns `{propertyId, widgetId}` (both nullable).
({String? propertyId, String? widgetId}) _parseTawkUrl(final String chatUrl) {
  try {
    final uri = Uri.tryParse(chatUrl);
    if (uri == null) {
      return (propertyId: null, widgetId: null);
    }

    final segments = uri.pathSegments;
    if (segments.length < 3) {
      return (propertyId: null, widgetId: null);
    }

    // Find 'chat' segment and check we have property and widget after it
    for (var i = 0; i < segments.length - 2; i++) {
      if (segments[i] == 'chat' &&
          segments[i + 1].isNotEmpty &&
          segments[i + 2].isNotEmpty) {
        return (propertyId: segments[i + 1], widgetId: segments[i + 2]);
      }
    }
  } on Exception catch (_) {}
  return (propertyId: null, widgetId: null);
}

/// Extracts property ID from chat URL.
String? getPropertyId(final String chatUrl) =>
    _parseTawkUrl(chatUrl).propertyId;

/// Extracts widget ID from chat URL.
String? getWidgetId(final String chatUrl) => _parseTawkUrl(chatUrl).widgetId;

/// Builds HTML page with iframe for mobile WebView fallback.
String buildIframeHtml(final String chatUrl, {final String? allowAttrs}) {
  final allow = allowAttrs ?? 'clipboard-write';
  return '''
    <!doctype html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>html,body{height:100%;margin:0;padding:0;}#tawk-iframe{height:100%;width:100%;border:0;}</style>
        </head>
        <body>
          <iframe id="tawk-iframe" src="$chatUrl" frameborder="0" allow="$allow"></iframe>
        </body>
      </html>
    ''';
}

/// Gets Tawk.to script content for DOM injection.
String getTawkScriptContent(final String embedSrc) {
  return '''
    var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
    (function(){
    var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
    s1.async=true;
    s1.src='$embedSrc';
    s1.charset='UTF-8';
    s1.setAttribute('crossorigin','*');
    s0.parentNode.insertBefore(s1,s0);
    })();
    ''';
}

/// Builds HTML with Tawk.to script injection for web platforms.
String _buildWebScriptHtml(final String embedSrc) {
  return '''
    <!doctype html>
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
        </head>
        <body>
          <div id="tawk-root"></div>
          <!--Start of Tawk.to Script-->
          <script type="text/javascript">
          ${getTawkScriptContent(embedSrc)}
          </script>
          <!--End of Tawk.to Script-->
        </body>
      </html>
    ''';
}

/// Builds platform-appropriate HTML: script injection for web,
/// iframe for mobile.
String buildTawkEmbedHtml(final String chatUrl) {
  final embedSrc = getEmbedScriptSrc(chatUrl);
  if (kIsWeb) {
    if (embedSrc == null) {
      return buildIframeHtml(chatUrl);
    }
    return _buildWebScriptHtml(embedSrc);
  }

  // Non-web: prefer iframe wrapper so the embed runs under the remote origin.
  return buildIframeHtml(chatUrl);
}
