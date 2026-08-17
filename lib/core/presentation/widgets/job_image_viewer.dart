import 'package:flutter/material.dart';
import 'package:wrench/core/presentation/widgets/job_image.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Hero tag shared between a thumbnail and its full-screen counterpart.
///
/// Keyed on the object path so two jobs never collide, and so a caller does
/// not have to thread an arbitrary tag through to both ends of the flight.
Object jobImageHeroTag(String path) => "job-image-$path";

/// Opens [path] full screen over the current route.
Future<void> showJobImage(BuildContext context, String path) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      pageBuilder: (context, _, _) => JobImageViewer(path: path),
      // The hero carries the image itself, so the page only needs to fade the
      // black ground in behind it.
      transitionsBuilder: (context, animation, _, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

/// Full-screen, zoomable view of a single piece of job media.
class JobImageViewer extends StatelessWidget {
  const JobImageViewer({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.close,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Hero(
          tag: jobImageHeroTag(path),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 5,
            child: JobImage(
              path: path,
              height: double.infinity,
              // Contain rather than cover: the point of opening this screen is
              // to see the parts the cropped thumbnail cut off.
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
