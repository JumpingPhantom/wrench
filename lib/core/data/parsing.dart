import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';

/// Runs [parse] over a payload from [source], reporting anything it throws as
/// a [ParsingException].
///
/// Reading a row is the one part of a request that runs outside
/// `remoteRequest`, and it is the part that fails as an [Error] rather than an
/// [Exception]: a missing column arrives as a `TypeError`, a value outside an
/// enum as an `ArgumentError`. Those slip past every `on AppException` in the
/// app, so a single unreadable row used to reach the screen as a blank with no
/// account of itself.
///
/// An [AppException] thrown inside [parse] is left alone — it already says what
/// it means.
T parsePayload<T>(String source, T Function() parse) {
  try {
    return parse();
  } on AppException {
    rethrow;
  } catch (e, stackTrace) {
    AppLogger.error("Could not read the payload from '$source'", e, stackTrace);

    throw ParsingException(
      message: "The payload does not match what the app expects",
      source: source,
      cause: e,
      stackTrace: stackTrace,
    );
  }
}

/// Reads [rows] one at a time, keeping the ones it understands.
///
/// A row that will not read is logged against [source] with whatever identifies
/// it, and skipped: one malformed record should cost one entry, not the whole
/// list. Parsing a table with a single `map().toList()` threw on the first bad
/// row and discarded every good one with it, which is how one profile carrying
/// an unmapped role emptied every name in the app.
///
/// Every row failing is a different thing from one row failing — it means the
/// table no longer matches the model — so that raises [ParsingException] rather
/// than returning an empty list, which would render as "unknown" everywhere and
/// explain nothing.
List<T> parseRows<T>(
  String source,
  List<Map<String, dynamic>> rows,
  T Function(Map<String, dynamic>) parse, {
  String idKey = "id",
}) {
  final parsed = <T>[];
  Object? lastFailure;

  for (final row in rows) {
    try {
      parsed.add(parse(row));
    } catch (e, stackTrace) {
      lastFailure = e;
      AppLogger.error(
        "Could not read '$source' row '${row[idKey]}'",
        e,
        stackTrace,
      );
    }
  }

  if (rows.isNotEmpty && parsed.isEmpty) {
    throw ParsingException(
      message:
          "None of the ${rows.length} rows could be read; "
          "the table does not match what the app expects",
      source: source,
      cause: lastFailure,
    );
  }

  return parsed;
}
