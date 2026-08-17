import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/data/models/user.dart';
import 'package:wrench/core/presentation/controllers/users_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Placeholder profile screen.
///
/// It shows the identity the app already knows about — name and role — so the
/// person icon leads somewhere real. Editing, avatars and sign-out are not
/// built yet; the notice at the bottom says so rather than offering controls
/// that do nothing.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: switch (ref.watch(currentUserProvider)) {
        AsyncData(value: final user?) => _ProfileBody(user: user, l10n: l10n),
        AsyncData() || AsyncError() => Center(child: Text(l10n.unknownUser)),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({required this.user, required this.l10n});

  final User user;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      children: [
        Center(
          child: CircleAvatar(
            radius: 44,
            backgroundColor: colorScheme.primaryContainer,
            // Initials rather than `user.avatarUrl`: nothing writes that column
            // yet, so its storage convention is still undecided.
            child: Text(
              _initials,
              style: textTheme.headlineMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user.fullName,
          textAlign: TextAlign.center,
          style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Center(
          child: Chip(
            label: Text(user.role.label(l10n), style: textTheme.labelSmall),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(height: 24),
        const Divider(indent: 16, endIndent: 16),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.profileComingSoon,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }

  /// Up to two initials, falling back to a neutral glyph for a blank name.
  String get _initials {
    final parts = user.fullName.trim().split(RegExp(r'\s+'))
      ..removeWhere((part) => part.isEmpty);

    if (parts.isEmpty) return "?";

    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }
}
