import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/repositories/media_repository.dart';
import 'package:wrench/core/data/sources/media_source.dart';
import 'package:wrench/core/data/sources/remote/remote_media_source.dart';

final _sourceProvider = Provider<MediaSource>((ref) => RemoteMediaSource());

final _repositoryProvider = Provider<MediaRepository>(
  (ref) => MediaRepository(source: ref.read(_sourceProvider)),
);

final mediaUrlProvider = FutureProvider.family<String?, String?>(
  (ref, path) async => ref.watch(_repositoryProvider).getMediaUrl(path),
);
