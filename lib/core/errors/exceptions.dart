/// Base class for errors the app raises on its own behalf.
///
/// [message] stays free of any category prefix so it can be logged or matched
/// on directly; [toString] adds the category for log output. User-facing copy
/// is chosen by the presentation layer from the exception type, never from
/// [message], which usually carries backend wording.
sealed class AppException implements Exception {
  AppException({required this.message, StackTrace? stackTrace})
    : stackTrace = stackTrace ?? StackTrace.current;

  final String message;
  final StackTrace stackTrace;

  /// Category name used when describing this exception in logs.
  String get label;

  /// Rethrows preserving the stack trace captured at construction.
  Never throwSelf() => Error.throwWithStackTrace(this, stackTrace);

  @override
  String toString() => "$label: $message";
}

/// An error that could not be attributed to a more specific cause.
class UnknownException extends AppException {
  UnknownException({required super.message, super.stackTrace});

  @override
  String get label => "Unknown error";
}

/// The backend was unreachable, or rejected the request.
class NetworkException extends AppException {
  NetworkException({required super.message, super.stackTrace});

  @override
  String get label => "Network error";
}

/// A request reached the backend but the operation itself did not succeed.
class OperationException extends AppException {
  OperationException({required super.message, super.stackTrace});

  @override
  String get label => "Operation error";
}

/// The app is missing configuration it needs to run.
class ConfigurationException extends AppException {
  ConfigurationException({required super.message, super.stackTrace});

  @override
  String get label => "Configuration error";
}
