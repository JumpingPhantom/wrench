import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteJobsSource implements JobsSource {
  static const mediaBucket = "media";

  @override
  Future<List<Job>> getAllJobs() async {
    try {
      final rows = await client
          .from("jobs")
          .select("*")
          .order("created_at", ascending: false);

      return rows.map(Job.fromJson).toList();
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error("Failed to load jobs", e, stackTrace);
      throw NetworkException(message: e.message, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> saveJob(Job job) async {
    final localPath = job.mediaUrl;

    // Upload before inserting: a job row pointing at media that never made it
    // to storage is worse than no row at all, since nothing retries it later.
    if (localPath != null) {
      job = job.copyWith(mediaUrl: await _uploadMedia(localPath));
    }

    try {
      await client.from("jobs").insert(job.toJson());
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error("Failed to save job", e, stackTrace);
      throw NetworkException(message: e.message, stackTrace: stackTrace);
    }
  }

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

    try {
      final row = await client
          .from("jobs")
          .update(payload)
          .eq("id", id)
          .select()
          .single();

      return Job.fromJson(row);
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error("Failed to update job $id", e, stackTrace);
      throw NetworkException(message: e.message, stackTrace: stackTrace);
    }
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
      await client.storage
          .from(mediaBucket)
          .upload(objectPath, File(localPath));

      return objectPath;
    } on StorageException catch (e, stackTrace) {
      AppLogger.error("Failed to upload job media", e, stackTrace);
      throw OperationException(message: e.message, stackTrace: stackTrace);
    }
  }

  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError("deleteJob is not implemented yet");
  }
}
