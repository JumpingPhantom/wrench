import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, StorageException;
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/network/remote_request.dart';

void main() {
  group("remoteRequest", () {
    test("passes a result straight through", () async {
      expect(await remoteRequest("do the thing", () async => 42), 42);
    });

    test("reports a backend that answers with an error", () async {
      expect(
        () => remoteRequest(
          "load jobs",
          () async => throw PostgrestException(message: "permission denied"),
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test("reports a backend that cannot be reached", () async {
      // What a phone with no route to the host actually raises. It used to
      // escape as-is, past every `on AppException` in the app.
      expect(
        () => remoteRequest(
          "load jobs",
          () async => throw const SocketException("No route to host"),
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test("reports a request that never answers", () async {
      expect(
        () => remoteRequest(
          "load jobs",
          () => Completer<int>().future,
          timeout: const Duration(milliseconds: 20),
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test("reports any other transport failure", () async {
      expect(
        () => remoteRequest(
          "load jobs",
          () async => throw const FormatException("connection closed"),
        ),
        throwsA(isA<NetworkException>()),
      );
    });

    test("leaves a storage failure for its own caller to read", () async {
      // The media paths tell "the object is unreadable" from "the network is
      // down" by type, so this one must not be rewritten on the way past.
      expect(
        () => remoteRequest(
          "upload media",
          () async => throw const StorageException("Object not found"),
        ),
        throwsA(isA<StorageException>()),
      );
    });

    test("leaves an error alone, since that is a bug and not a network", () {
      expect(
        () => remoteRequest("load jobs", () async => throw StateError("bug")),
        throwsA(isA<StateError>()),
      );
    });
  });
}
