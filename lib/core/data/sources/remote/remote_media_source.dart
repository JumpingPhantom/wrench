import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/sources/media_source.dart';
import 'package:wrench/core/data/sources/remote/remote_jobs_source.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

/// Supabase-backed [MediaSource]: signs objects held in
/// [RemoteJobsSource.mediaBucket] for temporary read access.
class RemoteMediaSource extends MediaSource {
  /// Long enough to cover a browsing session, so images already on screen do
  /// not break while the user is still looking at them.
  static const _signedUrlTtl = Duration(hours: 1);

  /// Returns a signed URL for [path], or null if it could not be resolved.
  ///
  /// [path] is bucket-relative ("images/123.jpg") — the bucket prefix is added
  /// by the storage client, so passing an already-prefixed key yields a 404.
  @override
  Future<String?> getImageUrl(String? path) async {
    if (path == null) return null;

    try {
      return await client.storage
          .from(RemoteJobsSource.mediaBucket)
          .createSignedUrl(path, _signedUrlTtl.inSeconds);
    } on StorageException catch (e, stackTrace) {
      // A missing or unreadable image degrades to a placeholder rather than
      // taking down the screen around it.
      AppLogger.error("Failed to sign media URL for '$path'", e, stackTrace);
      return null;
    }
  }
}
