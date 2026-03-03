import 'package:flutter/material.dart';

/// Stub implementation used on non-web platforms when the web-specific
/// DOM-based `TawkChatWeb` is not available. This keeps the conditional
/// import compile-time correct while providing a no-op placeholder.
class TawkChatWeb extends StatelessWidget {
  /// Creates a TawkChatWeb instance.
  const TawkChatWeb({super.key, required this.chatUrl, this.initialHeight});

  /// The full tawk chat URL. Present for API parity with the web widget.
  final String chatUrl;

  /// Optional height reserved for the placeholder.
  final double? initialHeight;

  @override
  Widget build(final BuildContext context) {
    // This stub shouldn't be used on non-web platforms. Provide a placeholder.
    return const SizedBox.shrink();
  }
}
