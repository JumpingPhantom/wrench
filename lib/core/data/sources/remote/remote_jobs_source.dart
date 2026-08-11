import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/models/job.dart';
import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/core/network/supabase_client.dart';
import 'package:wrench/core/utils.dart';

class RemoteJobsSource implements JobsSource {
  @override
  Future<List<Job>> getAllJobs() async {
    final jobs = jobsFromDB(await client.from("jobs").select("*"));

    return jobs;
  }

  @override
  Future<void> saveJob(Job job) async {
    // TODO: handle the image upload first before saving the job if there's any
    final mediaUrl = job.mediaUrl;

    if (mediaUrl != null) {
      final file = File(mediaUrl);
      final fileName = "${DateTime.now().millisecondsSinceEpoch}";
      final filePath = "media/$fileName";
      final String fileRef;

      try {
        fileRef = await client.storage.from("media").upload(filePath, file);
        job = job.copyWith(mediaUrl: fileRef);
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Future<void> deleteJob(Job job) async {
    throw UnimplementedError('Supabase not yet configured');
  }
}
