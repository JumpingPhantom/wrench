import 'package:flutter_test/flutter_test.dart';
import 'package:wrench/core/errors/exceptions.dart';

void main() {
  group('AppException', () {
    test('defaults to a non-null stack trace', () {
      final exception = UnknownException(message: 'boom');

      expect(exception.stackTrace, isNotNull);
    });

    test('throwSelf throws the exception instance', () {
      final exception = UnknownException(message: 'boom');

      expect(exception.throwSelf, throwsA(same(exception)));
    });
  });

  group('exception message prefixes', () {
    test('UnknownException prefixes with "Unknown error:"', () {
      expect(UnknownException(message: 'boom').message, 'Unknown error: boom');
    });

    test('NetworkException prefixes with "Network error:"', () {
      expect(NetworkException(message: 'boom').message, 'Network error: boom');
    });

    test('OperationException prefixes with "Operation error:"', () {
      expect(
        OperationException(message: 'boom').message,
        'Operation error: boom',
      );
    });

    test('ConfigurationException prefixes with "Configuration error:"', () {
      expect(
        ConfigurationException(message: 'boom').message,
        'Configuration error: boom',
      );
    });
  });
}
