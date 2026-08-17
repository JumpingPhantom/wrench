import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wrench/core/data/sources/media_source.dart';
import 'package:wrench/core/logging/app_logger.dart';
import 'package:wrench/core/network/supabase_client.dart';

class RemoteMediaSource extends MediaSource {
  @override
  Future<String?> getImageUrl(String? path) async {
    if (path == null) return null;

    try {
      final url = await client.storage.from("media").createSignedUrl(path, 60);

      return url;
    } on StorageException catch (e) {
      AppLogger.error(e.message);
    }

    return null;
  }
}
