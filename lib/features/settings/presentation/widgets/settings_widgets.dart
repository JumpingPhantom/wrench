import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/core/presentation/widgets/detail_row.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The languages the app offers, and how each one names itself.
///
/// `system` is first because following the device is the answer most people
/// want; the rest carry their own endonym so they can be recognised by someone
/// who cannot read the current language.
List<({String code, String label})> languageOptions(AppLocalizations l10n) => [
  (code: 'system', label: l10n.system),
  (code: 'en', label: 'English'),
  (code: 'ar', label: 'العربية'),
];

/// How the stored language code reads on screen.
String languageLabel(String code, AppLocalizations l10n) {
  for (final option in languageOptions(l10n)) {
    if (option.code == code) return option.label;
  }
  return l10n.system;
}

/// Theme choice as three segments rather than a menu: there are only three
/// answers and the current one is worth seeing without opening anything.
class ThemeTile extends StatelessWidget {
  const ThemeTile({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  final ThemeMode currentMode;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.palette_outlined,
                size: 18,
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Text(l10n.theme, style: textTheme.bodyMedium),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: [
              _segment(ThemeMode.light, Icons.light_mode, l10n.light),
              _segment(ThemeMode.dark, Icons.dark_mode, l10n.dark),
              _segment(ThemeMode.system, Icons.phone_android, l10n.system),
            ],
            selected: {currentMode},
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSelectionChanged: (selected) => onChanged(selected.first),
          ),
        ),
      ],
    );
  }

  /// The icon rides inside the label rather than in `ButtonSegment.icon`:
  /// a segment that fills `icon` has its padding overridden with a fixed 28
  /// logical pixels of horizontal inset, which on a narrow screen leaves the
  /// longest label — `System` — too little room and wraps it mid-word. Owning
  /// the row keeps the padding this widget asks for, and ellipsis is the
  /// fallback when a large text scale still runs out of width.
  ButtonSegment<ThemeMode> _segment(
    ThemeMode value,
    IconData icon,
    String label,
  ) {
    return ButtonSegment(
      value: value,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

/// Language as a row that states its own answer, so the setting can be read
/// without opening the picker.
class LanguageTile extends StatelessWidget {
  const LanguageTile({
    super.key,
    required this.currentCode,
    required this.onChanged,
  });

  final String currentCode;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DetailRow(
      icon: Icons.translate,
      label: l10n.language,
      value: languageLabel(currentCode, l10n),
      onTap: () => _showLanguagePicker(context, l10n),
    );
  }

  void _showLanguagePicker(BuildContext context, AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    l10n.selectLanguage,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              RadioGroup<String>(
                groupValue: currentCode,
                onChanged: (value) {
                  if (value != null) onChanged(value);
                  context.pop();
                },
                child: Column(
                  children: languageOptions(l10n)
                      .map(
                        (language) => RadioListTile<String>(
                          title: Text(language.label),
                          value: language.code,
                        ),
                      )
                      .toList(),
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
