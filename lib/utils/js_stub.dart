/// A stub for dart:js to allow compilation on non-web platforms.
class JsObject {
  void callMethod(String method, [List? args]) {}
  static JsObject jsify(Object object) => JsObject();
}

final JsObject context = JsObject();
