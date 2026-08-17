// ignore_for_file: empty_catches, unused_catch_clause

import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteJobsSource implements JobsSource {
  @override
  Future<List<Job>> getAllJobs() async {
    final List<Job> jobs;

    try {
      final query = await client.from("jobs").select("*");
      jobs = query.map((res) => Job.fromJson(res)).toList();

      return jobs;
    } on PostgrestException catch (e) {
      rethrow;
    }
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
      }
    }

    try {
      await client.from("jobs").insert(job.toJson());
    } on PostgrestException catch (e) {}
  }

  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}
