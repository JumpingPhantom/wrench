import 'package:wrench/core/data/sources/jobs_source.dart';
import 'package:wrench/core/data/sources/media_source.dart';

/// The app's entry point for media stored against a job.
///
/// Only reads live here. Uploads happen inside [JobsSource.saveJob], where the
/// media and the row that points at it are written as one operation.
class MediaRepository {
  MediaRepository({required this.source});

  final MediaSource source;

  /// Returns a displayable URL for the stored [path], or null if there is
  /// nothing to show — a job without media, or an image that failed to resolve.
  Future<String?> getMediaUrl(String? path) => source.getImageUrl(path);
}
