import 'dart:html' as html;

// This file provides the web-specific implementation.
String getRedirectUrl() {
  return html.window.location.origin;
}