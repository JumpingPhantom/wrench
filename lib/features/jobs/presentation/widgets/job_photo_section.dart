import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

/// The photo slot: the shot once there is one, the invitation to take it until
/// then.
class PhotoSection extends StatelessWidget {
  const PhotoSection({
    super.key,
    required this.photo,
    required this.onCapture,
    required this.onRemove,
    required this.l10n,
  });

  final File? photo;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;

    if (photo == null) return PhotoPicker(onTap: onCapture, l10n: l10n);

    return PhotoPreview(
      photo: photo,
      onCapture: onCapture,
      onRemove: onRemove,
      l10n: l10n,
    );
  }
}

class PhotoPreview extends StatelessWidget {
  const PhotoPreview({
    super.key,
    required this.photo,
    required this.onCapture,
    required this.onRemove,
    required this.l10n,
  });

  final File photo;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: AlignmentDirectional.bottomEnd,
        children: [
          Image.file(
            photo,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          PositionedDirectional(
            end: 8,
            bottom: 8,
            child: Row(
              children: [
                PhotoAction(
                  icon: Icons.refresh,
                  label: l10n.retake,
                  onTap: onCapture,
                ),
                const SizedBox(width: 8),
                PhotoAction(
                  icon: Icons.delete_outline,
                  label: l10n.removePhoto,
                  onTap: onRemove,
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhotoAction extends StatelessWidget {
  const PhotoAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isDestructive
                    ? colorScheme.error
                    : colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: isDestructive
                      ? colorScheme.error
                      : colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoPicker extends StatelessWidget {
  const PhotoPicker({super.key, required this.onTap, required this.l10n});

  final VoidCallback onTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 36),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 32,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.addPhotoHint,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
