sealed class AppException implements Exception {
  final String message;
  final StackTrace stackTrace;

  AppException({required this.message, StackTrace? stackTrace})
    : stackTrace = stackTrace ?? StackTrace.current;

  Never throwSelf() {
    Error.throwWithStackTrace(this, stackTrace);
  }
}

class UnknownException extends AppException {
  UnknownException({required super.message});

  @override
  String get message => "Unknown error: ${super.message}";
}

class NetworkException extends AppException {
  NetworkException({required super.message});

  @override
  String get message => "Network error: ${super.message}";
}

class OperationException extends AppException {
  OperationException({required super.message});

  @override
  String get message => "Operation error: ${super.message}";
}
