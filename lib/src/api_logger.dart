class ApiLogger {
  ApiLogger._();

  static List<OnError> onErrorMiddleware = [];
}

typedef OnError = Function(String message, Exception e, StackTrace stack);
