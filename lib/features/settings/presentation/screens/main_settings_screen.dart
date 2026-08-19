import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/presentation/controllers/settings_provider.dart';
import 'package:wrench/core/presentation/widgets/detail_row.dart';
import 'package:wrench/core/presentation/widgets/error_state.dart';
import 'package:wrench/core/presentation/widgets/section_card.dart';
import 'package:wrench/features/settings/presentation/widgets/settings_widgets.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// Settings, grouped into the same cards the job screens use.
class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});

  /// Until something reads it from the build, this is the one place the number
  /// is written down.
  static const _version = "0.1.0";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      body: switch (settings) {
        AsyncData(:final value) => ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            SectionCard(
              title: l10n.appearance,
              child: Column(
                children: [
                  ThemeTile(
                    currentMode: value.themeMode,
                    onChanged: (mode) =>
                        ref.read(settingsProvider.notifier).setThemeMode(mode),
                  ),
                  const SizedBox(height: 18),
                  LanguageTile(
                    currentCode: value.localeCode,
                    onChanged: (code) =>
                        ref.read(settingsProvider.notifier).setLocaleCode(code),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.account,
              child: DetailRow(
                icon: Icons.person_outline,
                label: l10n.profile,
                onTap: () => context.push('/profile'),
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: l10n.about,
              child: DetailRow(
                icon: Icons.info_outline,
                label: l10n.version,
                value: _version,
              ),
            ),
          ],
        ),
        AsyncError(:final error) => ErrorState(
          error: error,
          onRetry: () => ref.invalidate(settingsProvider),
        ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
