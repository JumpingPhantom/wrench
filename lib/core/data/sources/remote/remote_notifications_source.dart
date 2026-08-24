import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/app_notification.dart';
import 'package:wrench/core/data/models/instant.dart';
import 'package:wrench/core/data/parsing.dart';
import 'package:wrench/core/data/sources/notifications_source.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [NotificationsSource]: rows in the `notifications` table.
///
/// Which rows come back is decided by row-level security rather than by any
/// filter here, so nothing below scopes by recipient. Writes are narrower still:
/// the table grants `update (read_at)` and nothing else, so marking read is the
/// only thing this class can change even if it tried to send more.
class RemoteNotificationsSource implements NotificationsSource {
  /// Topic the change feed subscribes to. `channel()` does not deduplicate by
  /// name, so a feed removes its own channel when it ends rather than leaving a
  /// second one on the socket for the next listener to trip over.
  static const _changesChannel = "public:notifications";

  @override
  Future<List<AppNotification>> getRecent({
    int limit = NotificationsSource.defaultLimit,
  }) async {
    // Ordered explicitly, with the id breaking ties: Postgres makes no ordering
    // guarantee without an ORDER BY, so the limit would otherwise return an
    // arbitrary window, and two notifications sharing a timestamp have no order
    // of their own.
    final rows = await remoteRequest(
      "load notifications",
      () => client
          .from("notifications")
          .select("*")
          .order("created_at", ascending: false)
          .order("id", ascending: false)
          .limit(limit),
    );

    return parseRows("notifications", rows, AppNotification.fromJson);
  }

  /// Counts unread rows without transferring any of them.
  @override
  Future<int> unreadCount() => remoteRequest(
    "count unread notifications",
    () => client
        .from("notifications")
        .count(CountOption.exact)
        .isFilter("read_at", null),
  );

  /// Changes to the `notifications` table, over a Supabase realtime channel.
  ///
  /// The channel is opened when the first listener arrives and torn down when
  /// the last one leaves, so nothing holds a socket open for a screen that is
  /// no longer watching.
  ///
  /// Inserts and updates both matter: a new notification arrives as an insert,
  /// and one marked read on another device arrives as an update. Both mean the
  /// same thing to a listener -- ask again -- so both emit the same signal.
  @override
  Stream<void> watch() {
    late final StreamController<void> controller;
    RealtimeChannel? channel;

    // Set while the feed is being taken down on purpose, so the statuses that
    // teardown produces are not reported as the connection failing.
    var closing = false;

    void open() {
      channel = client
          .channel(_changesChannel)
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: "public",
            table: "notifications",
            callback: (_) => controller.add(null),
          )
          .subscribe((status, error) {
            switch (status) {
              case RealtimeSubscribeStatus.subscribed:
                // Every join, not just the ones after the first. A feed coming
                // back cannot say what it missed while it was away, and asking
                // again is the answer to that as much as to a row changing --
                // so unlike the jobs feed there is nothing to distinguish here.
                controller.add(null);
              case RealtimeSubscribeStatus.channelError:
              case RealtimeSubscribeStatus.timedOut:
              case RealtimeSubscribeStatus.closed:
                // Left to the client, which rejoins on its own. The rejoin is
                // what prompts the refetch, so there is nothing to emit here.
                if (closing) return;

                AppLogger.warning(
                  "Notifications change feed is ${status.name}"
                  "${error == null ? "" : ": $error"}",
                );
            }
          });
    }

    Future<void> close() async {
      final open = channel;
      channel = null;
      closing = true;

      if (open != null) await client.removeChannel(open);

      closing = false;
    }

    controller = StreamController<void>.broadcast(
      onListen: open,
      onCancel: close,
    );

    return controller.stream;
  }

  @override
  Future<void> markRead(int id) async {
    await remoteRequest(
      "mark notification $id read",
      () => client
          .from("notifications")
          .update({"read_at": _now()})
          .eq("id", id)
          // Already-read rows are left alone, so re-reading one does not
          // rewrite the instant it was first read at.
          .isFilter("read_at", null),
    );
  }

  @override
  Future<void> markAllRead() async {
    await remoteRequest(
      "mark all notifications read",
      // The filter is also what keeps this a legal request: PostgREST rejects
      // an unfiltered update outright.
      () => client
          .from("notifications")
          .update({"read_at": _now()})
          .isFilter("read_at", null),
    );
  }

  /// The current instant in the wire format every other timestamp uses.
  String _now() => instantToJson(DateTime.now().toUtc());
}
