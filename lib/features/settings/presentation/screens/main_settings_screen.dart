import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wrench/core/providers/settings_provider.dart';

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
          _SectionHeader(title: l10n.appearance),
          SizedBox(
            width: double.infinity,
            child: _ThemeTile(
              currentMode: settings.themeMode,
              onChanged: (mode) {
                ref.read(settingsProvider.notifier).setThemeMode(mode);
              },
            ),
          ),
          const Divider(indent: 16, endIndent: 16),
          _LanguageTile(
            currentCode: settings.localeCode,
            onChanged: (code) {
              ref.read(settingsProvider.notifier).setLocaleCode(code);
            },
          ),
          const Divider(indent: 16, endIndent: 16),
          const SizedBox(height: 8),
          _SectionHeader(title: l10n.about),
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile({required this.currentMode, required this.onChanged});

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      title: SegmentedButton<ThemeMode>(
        segments: [
          ButtonSegment(
            value: ThemeMode.light,
            label: Text(l10n.light),
            icon: const Icon(Icons.light_mode, size: 18),
          ),
          ButtonSegment(
            value: ThemeMode.dark,
            label: Text(l10n.dark),
            icon: const Icon(Icons.dark_mode, size: 18),
          ),
          ButtonSegment(
            value: ThemeMode.system,
            label: Text(l10n.system),
            icon: const Icon(Icons.phone_android, size: 18),
          ),
        ],
        selected: {currentMode},
        onSelectionChanged: (selected) {
          onChanged(selected.first);
        },
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.currentCode, required this.onChanged});

  final String currentCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListTile(
      leading: const Icon(Icons.language),
      title: Text(l10n.language),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => _showLanguagePicker(context),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final languages = [
      (code: 'system', label: l10n.system, nativeLabel: l10n.system),
      (code: 'en', label: 'English', nativeLabel: 'English'),
      (code: 'ar', label: 'Arabic', nativeLabel: 'العربية'),
    ];

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.selectLanguage,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              ...languages.map(
                (lang) => RadioListTile<String>(
                  title: Text('${lang.label} (${lang.nativeLabel})'),
                  value: lang.code,
                  groupValue: currentCode,
                  onChanged: (value) {
                    if (value != null) onChanged(value);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
