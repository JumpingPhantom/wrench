/// Resolves stored media into URLs the app can actually display.
abstract class MediaSource {
  /// Returns a displayable URL for [path], or null if there is nothing to show.
  ///
  /// A null [path] (a job without media) and an image that cannot be resolved
  /// are deliberately the same answer: callers render a placeholder either way,
  /// so this never throws.
  Future<String?> getImageUrl(String? path);
}
