import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wrench/core/data/models/job.dart';

part "job_change.freezed.dart";

/// One thing that happened to the `jobs` table, as reported by the change feed.
///
/// The feed carries changes rather than rows: the queries that read jobs are
/// filtered, paged and counted at the database, and none of that survives being
/// re-run over a snapshot pushed from a socket. A listener holds whatever it
/// already fetched and reconciles these against it.
@freezed
sealed class JobChange with _$JobChange {
  /// A job was inserted or updated; [job] is the row as it now stands.
  ///
  /// Insert and update arrive as one case because a listener has to do the same
  /// thing with either: hold this row under this id, in place of whatever it
  /// held before.
  const factory JobChange.upserted(Job job) = JobUpserted;

  /// The job with [id] is no longer in the table.
  const factory JobChange.removed(int id) = JobRemoved;

  /// The feed resumed after being down, and cannot say what it missed.
  ///
  /// A socket drops whenever the phone sleeps or changes network, and the
  /// changes committed in between are gone rather than queued — nothing replays
  /// them on reconnect. So a listener holding data has to fetch it again rather
  /// than patch it, or it will show rows that stopped being true while it was
  /// away and go on showing them until somebody touches them a second time.
  const factory JobChange.desynced() = JobsDesynced;
}
