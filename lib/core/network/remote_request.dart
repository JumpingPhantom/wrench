import 'dart:async';
import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart'
    show
        AuthException,
        AuthRetryableFetchException,
        PostgrestException,
        StorageException;
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';

/// How long a request may run before it is treated as a failure.
///
/// Without a deadline, a request made with no route to the backend waits on the
/// platform's own TCP timeout — minutes on a phone holding a Wi-Fi association
/// that carries no internet — and the screen waiting on it shows a spinner for
/// every one of them.
const networkTimeout = Duration(seconds: 20);

/// Longer, for a request whose own size is the reason it is slow.
const uploadTimeout = Duration(seconds: 60);

/// Runs [request] against the backend under a deadline, reporting every way the
/// transport can fail as a [NetworkException].
///
/// The sources used to catch only [PostgrestException] — what the backend
/// throws when it answers with an error. The case where it never answers at all
/// arrived as a raw socket failure instead and escaped every `on AppException`
/// in the app: screens that catch one to show a message let it through, and a
/// button that had set itself busy first stayed that way.
///
/// [StorageException] and [AuthException] are passed through rather than
/// translated: an object that cannot be read and a password that is wrong are
/// the backend refusing, not the network failing, and their callers map them to
/// their own meaning. The one auth failure that *is* the network —
/// [AuthRetryableFetchException], which is what gotrue wraps a failed fetch in
/// — is translated like any other.
///
/// [description] completes "failed to …" in the log.
Future<T> remoteRequest<T>(
  String description,
  Future<T> Function() request, {
  Duration timeout = networkTimeout,
}) async {
  try {
    return await request().timeout(timeout);
  } on StorageException {
    rethrow;
  } on AuthRetryableFetchException catch (e, stackTrace) {
    AppLogger.error(
      "Could not reach the backend to $description",
      e,
      stackTrace,
    );
    throw NetworkException(message: e.message, stackTrace: stackTrace);
  } on AuthException {
    rethrow;
  } on PostgrestException catch (e, stackTrace) {
    AppLogger.error("Failed to $description", e, stackTrace);
    throw NetworkException(message: e.message, stackTrace: stackTrace);
  } on TimeoutException catch (e, stackTrace) {
    AppLogger.error("Timed out trying to $description", e, stackTrace);
    throw NetworkException(
      message: "Timed out after ${timeout.inSeconds}s trying to $description",
      stackTrace: stackTrace,
    );
  } on SocketException catch (e, stackTrace) {
    AppLogger.error(
      "Could not reach the backend to $description",
      e,
      stackTrace,
    );
    throw NetworkException(message: e.message, stackTrace: stackTrace);
  } on Exception catch (e, stackTrace) {
    // Whatever else the HTTP client raises when it cannot complete a call —
    // a handshake that failed, a connection closed mid-response. Errors are
    // left alone: those are this app's own bugs, not the network's.
    AppLogger.error("Failed to $description", e, stackTrace);
    throw NetworkException(message: e.toString(), stackTrace: stackTrace);
  }
}
