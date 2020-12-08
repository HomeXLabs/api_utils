/// Add logging to your api calls in one place
class ApiLogger {
  ApiLogger._();

  /// Add a callback function here to do whatever you want with the error
  /// information. You can add multiple or remove if you need to.
  static List<OnError> onErrorMiddleware = [];
}

typedef OnError = Function(String message, Exception? e, StackTrace? stack);
