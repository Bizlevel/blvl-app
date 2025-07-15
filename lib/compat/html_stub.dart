/// Stub implementation for non-web platforms so that conditional import
/// for `dart:html` compiles on mobile / desktop.
/// This file is only included when `dart.library.html` is NOT available.

class IFrameElement {
  String? src;
  dynamic style = _Style();
  bool allowFullscreen = false;
}

class _Style {
  String border = '';
}
