import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteJobsSource implements JobsSource {
  @override
  Future<List<Job>> getAllJobs() async {
    AppLogger.info("RemoteJobsSource: getting jobs...");

    final query = await client.from("jobs").select("*");
    final jobs = query.map((res) => Job.fromJson(res)).toList();
    return jobs;
  }

  @override
  Future<void> saveJob(Job job) async {
    final mediaUrl = job.mediaUrl;

    if (mediaUrl != null) {
      final file = File(mediaUrl);
      final fileName = "${DateTime.now().millisecondsSinceEpoch}";
      final filePath = "images/$fileName";
      final String fileRef;

      try {
        fileRef = await client.storage.from("media").upload(filePath, file);
        job = job.copyWith(mediaUrl: fileRef);
      } on StorageException catch (e) {
        // TODO: handle the case of failure and show a toast explaining what happened
        AppLogger.error(e.message, StackTrace.current);
      }
    }

    AppLogger.info("${job.toJson()}");
    try {
      await client.from("jobs").insert(job.toJson());
    } on PostgrestException catch (e) {
      AppLogger.error(e.message, StackTrace.current);
    }
  }

  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}
