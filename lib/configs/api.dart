import 'dart:js_interop';
import 'package:flutter/foundation.dart';

@JS()
external Window get window;

@JS()
extension type Window(JSObject _) implements JSObject {
  external Location get location;
}

@JS()
extension type Location(JSObject _) implements JSObject {
  external String get href;
  external String get hostname;
  external String get pathname;
}

String getApiHost() {
  if (!kReleaseMode) {
    return 'localhost:8080';
  }
  final uri = Uri.parse(window.location.href);
  return '${uri.host}:${uri.port}';
}