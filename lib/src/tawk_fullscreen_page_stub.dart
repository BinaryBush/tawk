import 'package:flutter/widgets.dart';

/// Builds a full-screen WebView page for web platforms.
/// This is a no-op since Tawk.to's embed script typically renders a
/// floating widget on web.
Widget buildTawkFullScreenPage({required final String chatUrl}) {
  return const SizedBox.shrink();
}
