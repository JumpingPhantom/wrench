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

/// The backend answered, but with a payload this app could not read.
///
/// A column that is absent, a value outside the enum it maps to, a timestamp
/// that will not parse: the table and the model disagree. Worth its own type
/// because it is the one backend failure retrying cannot help — and because
/// the parsers underneath raise [Error]s (a `TypeError` for a missing column,
/// an `ArgumentError` for an unmapped enum value), which slip past every
/// `on AppException` in the app and surface as an empty screen with no
/// explanation.
class ParsingException extends AppException {
  ParsingException({
    required super.message,
    this.source,
    this.cause,
    super.stackTrace,
  });

  /// What was being read — a table name, usually.
  final String? source;

  /// What the parser threw underneath, kept so a caller can report the actual
  /// mismatch rather than the fact that there was one.
  final Object? cause;

  @override
  String get label => "Parsing error";

  @override
  String toString() {
    final where = source == null ? "" : " in '$source'";
    final why = cause == null ? "" : " ($cause)";
    return "$label$where: $message$why";
  }
}

/// The app is missing configuration it needs to run.
class ConfigurationException extends AppException {
  ConfigurationException({required super.message, super.stackTrace});

  @override
  String get label => "Configuration error";
}
