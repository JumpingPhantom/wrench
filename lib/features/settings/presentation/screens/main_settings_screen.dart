import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/providers/settings_provider.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/features/settings/presentation/widgets/settings_widgets.dart';

class MainSettingsScreen extends ConsumerWidget {
  const MainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 8),
          SectionHeader(title: l10n.appearance),
          SizedBox(
            width: double.infinity,
            child: ThemeTile(
              currentMode: settings.themeMode,
              onChanged: (mode) {
                ref.read(settingsProvider.notifier).setThemeMode(mode);
              },
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          LanguageTile(
            currentCode: settings.localeCode,
            onChanged: (code) {
              ref.read(settingsProvider.notifier).setLocaleCode(code);
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          const SizedBox(height: 8),
          SectionHeader(title: l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            trailing: const Text('0.1.0'),
          ),
        ],
      ),
    );
  }
}
