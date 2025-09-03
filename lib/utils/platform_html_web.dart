import 'dart:html' as html;

class PlatformHtml {
  static String? get locationOrigin {
    return html.window.location.origin;
  }
}