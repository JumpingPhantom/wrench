import 'package:wrench/core/data/sources/media_source.dart';

class MediaRepository {
  MediaSource source;

  MediaRepository({required this.source});

  Future<String?> getMediaUrl(String? path) => source.getImageUrl(path);
}
