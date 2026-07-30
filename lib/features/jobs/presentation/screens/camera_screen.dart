import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/features/jobs/presentation/widgets/camera_overlay.dart';

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
    context.pop(File(_captured!.path));
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null && mounted) {
      context.pop(File(file.path));
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
            CapturedPhotoPreview(
              image: _captured!,
              l10n: l10n,
              onRetake: _retake,
              onUse: _usePhoto,
            )
          else
            CameraOverlay(
              controller: _controller,
              isInitialized: _isInitialized,
              isFlashOn: _isFlashOn,
              isBusy: _isBusy,
              flashAnimation: _flashAnimation,
              onFlashToggle: _toggleFlash,
              onCapture: _capture,
              onGallery: _pickFromGallery,
              onClose: () => context.pop(),
              l10n: l10n,
              colorScheme: colorScheme,
            ),
        ],
      ),
    );
  }
}
