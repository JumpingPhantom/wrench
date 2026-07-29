import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/features/jobs/presentation/screens/camera_screen.dart';

class CreateJobScreen extends StatefulWidget {
  const CreateJobScreen({super.key});

  @override
  State<CreateJobScreen> createState() => _CreateJobScreenState();
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  File? _photo;
  bool _submitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  bool get _isValid =>
      _titleController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  Future<void> _openCamera() async {
    final result = await Navigator.push<File>(
      context,
      MaterialPageRoute(builder: (_) => const CameraScreen()),
    );
    if (result != null && mounted) {
      setState(() => _photo = result);
    }
  }

  void _removePhoto() {
    setState(() => _photo = null);
  }

  Future<bool> _onWillPop() async {
    if (!_isValid && _photo == null) return true;
    final l10n = AppLocalizations.of(context)!;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.unsavedChanges),
        content: Text(l10n.discardJobDraft),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.discard),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!_isValid) {
      _titleFocus.requestFocus();
      return;
    }
    Navigator.pop(context, {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'photo': _photo,
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) Navigator.pop(context);
            },
          ),
          title: Text(l10n.createJob),
          titleTextStyle: textTheme.titleLarge,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilledButton(
                onPressed: _submit,
                child: Text(l10n.submit),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TitleField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  submitted: _submitted,
                  l10n: l10n,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                _DescriptionField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  l10n: l10n,
                ),
                const SizedBox(height: 28),
                _PhotoSection(
                  photo: _photo,
                  onCapture: _openCamera,
                  onRemove: _removePhoto,
                  l10n: l10n,
                  colorScheme: colorScheme,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.focusNode,
    required this.submitted,
    required this.l10n,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool submitted;
  final AppLocalizations l10n;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasError = submitted && controller.text.trim().isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.jobTitle,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.jobTitleHint,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            errorText: hasError ? l10n.requiredField : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.error),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({
    required this.controller,
    required this.focusNode,
    required this.l10n,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.description,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          focusNode: focusNode,
          maxLines: 6,
          minLines: 4,
          textInputAction: TextInputAction.newline,
          style: Theme.of(context).textTheme.bodyLarge,
          decoration: InputDecoration(
            hintText: l10n.describeTheIssue,
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            alignLabelWithHint: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photo,
    required this.onCapture,
    required this.onRemove,
    required this.l10n,
    required this.colorScheme,
  });

  final File? photo;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.addPhoto,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        if (photo != null)
          _PhotoPreview(
            photo: photo!,
            onCapture: onCapture,
            onRemove: onRemove,
            l10n: l10n,
            colorScheme: colorScheme,
          )
        else
          _PhotoPicker(onTap: onCapture, l10n: l10n, colorScheme: colorScheme),
      ],
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({
    required this.photo,
    required this.onCapture,
    required this.onRemove,
    required this.l10n,
    required this.colorScheme,
  });

  final File photo;
  final VoidCallback onCapture;
  final VoidCallback onRemove;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Image.file(
            photo,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: Row(
              children: [
                _PhotoAction(
                  icon: Icons.refresh,
                  label: l10n.retake,
                  onTap: onCapture,
                ),
                const SizedBox(width: 8),
                _PhotoAction(
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

class _PhotoAction extends StatelessWidget {
  const _PhotoAction({
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
                color: isDestructive ? colorScheme.error : colorScheme.onSurface,
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

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.onTap,
    required this.l10n,
    required this.colorScheme,
  });

  final VoidCallback onTap;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
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
