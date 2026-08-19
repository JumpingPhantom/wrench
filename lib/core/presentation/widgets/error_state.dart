import 'package:flutter/material.dart';
import 'package:wrench/core/errors/exceptions.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// What a surface shows when it could not load: what went wrong, and the way to
/// try it again.
///
/// A failed load is never left as a spinner. The screen has already stopped
/// waiting by the time this appears, and a user staring at an indicator that
/// will never resolve has no way to tell a slow network from a dead one.
///
/// [error] chooses the wording: a [NetworkException] is the phone's problem to
/// fix and says so, while anything else is the app's and only offers the retry.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, required this.onRetry, this.error});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final offline = error is NetworkException;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                offline ? Icons.wifi_off : Icons.cloud_off,
                size: 32,
                color: colors.onErrorContainer,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              offline ? l10n.noConnection : l10n.somethingWentWrong,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (offline) ...[
              const SizedBox(height: 6),
              Text(
                l10n.noConnectionHint,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton.tonalIcon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
