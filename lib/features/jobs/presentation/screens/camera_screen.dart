import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wrench/l10n/app_localizations.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isFlashOn = false;
  bool _isBusy = false;
  XFile? _captured;
  late AnimationController _flashAnimController;
  late Animation<double> _flashAnimation;

  @override
  void initState() {
    super.initState();
    _flashAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _flashAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flashAnimController, curve: Curves.easeOut),
    );
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty || !mounted) return;
    _controller = CameraController(cameras.first, ResolutionPreset.high);
    await _controller!.initialize();
    if (mounted) setState(() => _isInitialized = true);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _flashAnimController.dispose();
    super.dispose();
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;
    setState(() => _isFlashOn = !_isFlashOn);
    await _controller!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  Future<void> _capture() async {
    if (_controller == null || _isBusy) return;
    setState(() => _isBusy = true);
    try {
      _flashAnimController.forward(from: 0).then((_) {
        if (mounted) _flashAnimController.reset();
      });
      final file = await _controller!.takePicture();
      if (mounted) setState(() => _captured = file);
    } catch (_) {}
    if (mounted) setState(() => _isBusy = false);
  }

  Future<void> _retake() async {
    setState(() => _captured = null);
    await _controller?.resumePreview();
  }

  void _usePhoto() {
    if (_captured == null) return;
    Navigator.pop(context, File(_captured!.path));
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      Navigator.pop(context, File(file.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_captured != null)
            _PhotoPreview(
              image: _captured!,
              l10n: l10n,
              colorScheme: colorScheme,
              onRetake: _retake,
              onUse: _usePhoto,
            )
          else
            _CameraView(
              controller: _controller,
              isInitialized: _isInitialized,
              isFlashOn: _isFlashOn,
              isBusy: _isBusy,
              flashAnimation: _flashAnimation,
              onFlashToggle: _toggleFlash,
              onCapture: _capture,
              onGallery: _pickFromGallery,
              onClose: () => Navigator.pop(context),
              l10n: l10n,
              colorScheme: colorScheme,
            ),
        ],
      ),
    );
  }
}

class _CameraView extends StatelessWidget {
  const _CameraView({
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
        _TopBar(
          isFlashOn: isFlashOn,
          onFlashToggle: onFlashToggle,
          onClose: onClose,
        ),
        Expanded(
          child: Stack(
            children: [
              if (isInitialized && controller != null)
                Center(
                  child: CameraPreview(controller!),
                )
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
        _BottomBar(
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

class _TopBar extends StatelessWidget {
  const _TopBar({
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

class _BottomBar extends StatelessWidget {
  const _BottomBar({
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
            _CaptureButton(
              isBusy: isBusy,
              onPressed: onCapture,
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}

class _CaptureButton extends StatelessWidget {
  const _CaptureButton({required this.isBusy, required this.onPressed});

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

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.image,
    required this.l10n,
    required this.colorScheme,
    required this.onRetake,
    required this.onUse,
  });

  final XFile image;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
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
