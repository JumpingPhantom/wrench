import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay({
    super.key,
    required this.controller,
    required this.isInitialized,
    required this.isFlashOn,
    required this.isBusy,
    required this.flashAnimation,
    required this.onFlashToggle,
    required this.onCapture,
    required this.onGallery,
    required this.onClose,
    required this.l10n,
    required this.colorScheme,
  });

  final CameraController? controller;
  final bool isInitialized;
  final bool isFlashOn;
  final bool isBusy;
  final Animation<double> flashAnimation;
  final VoidCallback onFlashToggle;
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final VoidCallback onClose;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CameraTopBar(
          isFlashOn: isFlashOn,
          onFlashToggle: onFlashToggle,
          onClose: onClose,
        ),
        Expanded(
          child: Stack(
            children: [
              if (isInitialized && controller != null)
                Center(child: CameraPreview(controller!))
              else
                const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              AnimatedBuilder(
                animation: flashAnimation,
                builder: (context, child) {
                  return IgnorePointer(
                    child: Opacity(
                      opacity: flashAnimation.value,
                      child: Container(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        CameraBottomBar(
          isBusy: isBusy,
          onCapture: onCapture,
          onGallery: onGallery,
          l10n: l10n,
          colorScheme: colorScheme,
        ),
      ],
    );
  }
}

class CameraTopBar extends StatelessWidget {
  const CameraTopBar({
    super.key,
    required this.isFlashOn,
    required this.onFlashToggle,
    required this.onClose,
  });

  final bool isFlashOn;
  final VoidCallback onFlashToggle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: onClose,
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: isFlashOn ? Colors.amber : Colors.white,
                size: 28,
              ),
              onPressed: onFlashToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class CameraBottomBar extends StatelessWidget {
  const CameraBottomBar({
    super.key,
    required this.isBusy,
    required this.onCapture,
    required this.onGallery,
    required this.l10n,
    required this.colorScheme,
  });

  final bool isBusy;
  final VoidCallback onCapture;
  final VoidCallback onGallery;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: onGallery,
              icon: const Icon(Icons.photo_library_outlined),
              iconSize: 28,
              color: Colors.white,
              tooltip: l10n.addPhoto,
            ),
            CaptureButton(isBusy: isBusy, onPressed: onCapture),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class CaptureButton extends StatelessWidget {
  const CaptureButton({super.key, required this.isBusy, required this.onPressed});

  final bool isBusy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBusy ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isBusy ? Colors.white38 : Colors.white,
          ),
        ),
      ),
    );
  }
}

class CapturedPhotoPreview extends StatelessWidget {
  const CapturedPhotoPreview({
    super.key,
    required this.image,
    required this.l10n,
    required this.onRetake,
    required this.onUse,
  });

  final XFile image;
  final AppLocalizations l10n;
  final VoidCallback onRetake;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.file(
            File(image.path),
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
            ),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRetake,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retake),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: onUse,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.usePhoto),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
