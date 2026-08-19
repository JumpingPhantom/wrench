import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/remote_request.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [JobsSource]: rows in the `jobs` table, media in
/// [mediaBucket].
///
/// Which rows come back is decided by row-level security rather than by any
/// filter here, so the queries below never scope by user themselves.
class RemoteJobsSource implements JobsSource {
  static const mediaBucket = "media";
  static const _recentJobsLimit = 4;

  /// Reads one window of the table, narrowed by status and search before it
  /// leaves the database.
  @override
  Future<List<Job>> getJobsPage({
    required int offset,
    required int limit,
    JobStatus? status,
    String? search,
  }) async {
    var query = client.from("jobs").select("*");

    if (status != null) {
      query = query.eq("state->>status", status.storedName);
    }

    final term = _searchTerm(search);

    if (term != null) {
      query = query.or("title.ilike.%$term%,location.ilike.%$term%");
    }

    final rows = await remoteRequest(
      "load jobs page at $offset",
      () => query
          .order("created_at", ascending: false)
          .range(offset, offset + limit - 1),
    );

    return rows.map(Job.fromJson).toList();
  }

  /// Strips what `or()` reads as syntax before the term reaches it.
  ///
  /// The filter is assembled as a string, so a comma would start a new
  /// condition, a parenthesis would close the group, and `%` would widen the
  /// match — a search for "a,b" must not turn into a query the user did not
  /// ask for. Returns null when nothing searchable is left.
  String? _searchTerm(String? search) {
    final term = search?.replaceAll(RegExp(r'[,()%*\\]'), " ").trim();
    return term == null || term.isEmpty ? null : term;
  }

  @override
  Future<Job?> getJob(int id) async {
    final row = await remoteRequest(
      "load job $id",
      () => client.from("jobs").select("*").eq("id", id).maybeSingle(),
    );

    return row == null ? null : Job.fromJson(row);
  }

  /// Tallies statuses over a single column.
  ///
  /// One request returning just `state` beats five head-counts with a filter
  /// each, and the column is small enough that the saving is worth the rows.
  @override
  Future<Map<JobStatus, int>> getStatusCounts({String? createdBy}) async {
    var query = client.from("jobs").select("state");

    if (createdBy != null) {
      query = query.eq("created_by", createdBy);
    }

    final rows = await remoteRequest("count jobs by status", () => query);
    final counts = {for (final status in JobStatus.values) status: 0};

    for (final row in rows) {
      final state = row["state"] as Map<String, dynamic>?;
      final status = JobStatusColumn.fromStored(state?["status"] as String?);

      if (status != null) counts[status] = counts[status]! + 1;
    }

    return counts;
  }

  /// Applies [_recentJobsLimit] in the query rather than after the fact, so the
  /// request stays the same size however long the history gets.
  @override
  Future<List<Job>> getRecentJobs() async {
    // Postgres makes no ordering guarantee without an explicit ORDER BY, so
    // the limit below would otherwise return an arbitrary four rows.
    final rows = await remoteRequest(
      "load recent jobs",
      () => client
          .from("jobs")
          .select("*")
          .order("created_at", ascending: false)
          .limit(_recentJobsLimit),
    );

    return rows.map(Job.fromJson).toList();
  }

  /// Inserts [job], rewriting [Job.mediaUrl] from the local capture path to the
  /// stored object path on the way through.
  @override
  Future<void> saveJob(Job job) async {
    final localPath = job.mediaUrl;

    // Upload before inserting: a job row pointing at media that never made it
    // to storage is worse than no row at all, since nothing retries it later.
    if (localPath != null) {
      job = job.copyWith(mediaUrl: await _uploadMedia(localPath));
    }

    await remoteRequest(
      "save job",
      () => client.from("jobs").insert(job.toJson()),
    );
  }

  /// Sends only the mutable columns; media is not re-uploaded here, so an
  /// update cannot replace a job's photo.
  @override
  Future<Job> updateJob(Job job) async {
    final id = job.id;

    if (id == null) {
      throw OperationException(
        message: "Cannot update a job that has never been saved",
      );
    }

    // Only the mutable columns are sent. Identity and provenance are fixed at
    // creation, and replaying them here would collide with any row-level
    // policy that (correctly) forbids reassigning a job's author.
    final payload = job.toJson()
      ..remove("id")
      ..remove("created_at")
      ..remove("created_by");

    final row = await remoteRequest(
      "update job $id",
      () => client.from("jobs").update(payload).eq("id", id).select().single(),
    );

    return Job.fromJson(row);
  }

  /// Uploads the captured file and returns its **bucket-relative** object path.
  ///
  /// [StorageFileApi.upload] returns a bucket-prefixed key ("media/images/..."),
  /// but every read path — `createSignedUrl` in particular — prefixes the
  /// bucket itself. Storing the returned key would double the prefix and make
  /// the media unreadable, so the path we uploaded to is what gets persisted.
  Future<String> _uploadMedia(String localPath) async {
    final objectPath =
        "images/${DateTime.now().millisecondsSinceEpoch}"
        "${p.extension(localPath)}";

    try {
      await remoteRequest(
        "upload job media",
        () => client.storage
            .from(mediaBucket)
            .upload(objectPath, File(localPath)),
        timeout: uploadTimeout,
      );

      return objectPath;
    } on StorageException catch (e, stackTrace) {
      AppLogger.error("Failed to upload job media", e, stackTrace);
      throw OperationException(message: e.message, stackTrace: stackTrace);
    }
  }

  /// Not implemented: jobs are cancelled through [updateJob] rather than
  /// removed, and nothing in the app deletes one yet.
  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError("deleteJob is not implemented yet");
  }
}
