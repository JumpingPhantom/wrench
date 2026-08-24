import 'dart:async';

import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/sources/notifications_source.dart';
import 'package:wrench/core/errors/exceptions.dart';

/// An in-memory [NotificationsSource] that caps and counts the way the real one
/// is expected to, so a test can drive the providers without a backend.
///
/// It also records what it was asked for, which is how a test tells a read that
/// reached the source from one the providers quietly answered themselves.
class FakeNotificationsSource implements NotificationsSource {
  FakeNotificationsSource(this.notifications);

  List<AppNotification> notifications;

  /// When set, every read throws it instead of answering, which is how a test
  /// drives the providers with the network down.
  AppException? readError;

  /// When set, every write throws it instead of storing.
  AppException? writeError;

  /// One entry per read, in order.
  final List<int> recentRequests = [];
  int countRequests = 0;

  final _changes = StreamController<void>.broadcast();

  @override
  Stream<void> watch() => _changes.stream;

  /// Pushes a change down the feed, standing in for the backend having said so.
  ///
  /// Broadcast controllers drop what they are given while nobody is listening,
  /// so a test has to have read the provider before calling this.
  void emit() => _changes.add(null);

  /// Fails the feed, standing in for the socket going down.
  void emitError(Object error) => _changes.addError(error);

  Future<void> dispose() => _changes.close();

  @override
  Future<List<AppNotification>> getRecent({
    int limit = NotificationsSource.defaultLimit,
  }) async {
    _failIfAsked();
    recentRequests.add(limit);

    final newestFirst = [...notifications]
      ..sort((a, b) {
        final byTime = b.createdAt.compareTo(a.createdAt);
        return byTime != 0 ? byTime : b.id.compareTo(a.id);
      });

    return newestFirst.take(limit).toList();
  }

  /// Counts every unread row, not just the ones [getRecent] would return --
  /// which is the whole reason this is a separate call.
  @override
  Future<int> unreadCount() async {
    _failIfAsked();
    countRequests++;

    return notifications.where((entry) => !entry.isRead).length;
  }

  @override
  Future<void> markRead(int id) async {
    _failIfWriting();

    notifications = [
      for (final entry in notifications)
        if (entry.id == id && !entry.isRead)
          entry.copyWith(readAt: DateTime.utc(2026, 1, 1))
        else
          entry,
    ];
  }

  @override
  Future<void> markAllRead() async {
    _failIfWriting();

    notifications = [
      for (final entry in notifications)
        if (entry.isRead)
          entry
        else
          entry.copyWith(readAt: DateTime.utc(2026, 1, 1)),
    ];
  }

  void _failIfAsked() {
    final error = readError;
    if (error != null) throw error;
  }

  void _failIfWriting() {
    final error = writeError;
    if (error != null) throw error;
  }
}

/// A notification that differs from every other fixture only in what a test
/// changes, so two of them compare on the thing under test and nothing else.
AppNotification notificationWith({
  required int id,
  NotificationKind kind = NotificationKind.jobCreated,
  bool read = false,
  DateTime? createdAt,
}) => AppNotification(
  id: id,
  recipientId: "supervisor-1",
  actorId: "worker-1",
  jobId: id,
  kind: kind,
  createdAt: createdAt ?? DateTime.utc(2026, 1, 1).add(Duration(days: id)),
  readAt: read ? DateTime.utc(2026, 2, 1) : null,
);
