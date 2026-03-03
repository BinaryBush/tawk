# tawk

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.1.0] - 2025-09-30
### Added

- **TawkChat widget** with integration options
  - Controller-based API with `TawkController` for programmatic control
  - Direct URL usage for simple integrations
  - `TawkController.of(context)` for accessing controller anywhere in widget tree

- **Cross-platform support**
  - **Web**: DOM script injection using `dart:js_interop`
  - **Mobile/Desktop**: Full-screen WebView integration with `webview_flutter`
  - Automatic platform detection and appropriate rendering

- **Security & Privacy**
  - Minimal permission model
  - OnBackInvokedCallback support for Android 13+
