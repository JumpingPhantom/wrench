import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/presentation/controllers/media_provider.dart';

/// Renders job media held in private storage.
///
/// `Job.mediaUrl` is a bucket-relative object path, not a URL, so it has to be
/// exchanged for a short-lived signed URL before it can be fetched — a plain
/// [Image.network] on the stored value always fails.
class JobImage extends ConsumerWidget {
  const JobImage({
    super.key,
    required this.path,
    required this.height,
    this.width = double.infinity,
    this.fit = BoxFit.cover,
  });

  final String? path;
  final double height;
  final double width;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (path == null) return _fallback(context);

    return ref
        .watch(mediaUrlProvider(path))
        .when(
          data: (url) => url == null
              ? _fallback(context)
              : CachedNetworkImage(
                  imageUrl: url,
                  width: width,
                  height: height,
                  fit: fit,
                  placeholder: (context, _) => _loading(),
                  errorWidget: (context, _, _) => _fallback(context),
                ),
          loading: _loading,
          error: (_, _) => _fallback(context),
        );
  }

  Widget _loading() => SizedBox(
    width: width,
    height: height,
    child: const Center(child: CircularProgressIndicator()),
  );

  Widget _fallback(BuildContext context) => Container(
    width: width,
    height: height,
    color: Theme.of(context).colorScheme.surfaceContainerHighest,
    child: Icon(
      Icons.image_not_supported_outlined,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    ),
  );
}
