import 'package:wrench/core/data/sources/media_source.dart';

class MediaRepository {
  MediaRepository({required this.source});

  final MediaSource source;

  Future<String?> getMediaUrl(String? path) => source.getImageUrl(path);
}
