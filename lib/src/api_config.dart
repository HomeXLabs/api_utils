/// Configure Api Utils behavior
class ApiUtilsConfig {
  ApiUtilsConfig._();

  /// Add a callback function here to do whatever you want with the error
  /// information. You can add multiple or remove if you need to.
  static List<OnError> onErrorMiddleware = [];

  /// A global timeout for all requests. This can be overridden per request.
  /// Default behavior is no timeout.
  static Duration? timeout;
}

typedef OnError = Function(String message, Exception? e, StackTrace? stack);
