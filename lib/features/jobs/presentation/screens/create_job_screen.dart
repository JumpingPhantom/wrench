import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wrench/l10n/app_localizations.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_form_fields.dart';
import 'package:wrench/features/jobs/presentation/widgets/job_photo_section.dart';

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
    final result = await context.push<File>('/jobs/new/camera');
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
    context.pop({
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
        if (shouldPop && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) context.pop();
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
                TitleField(
                  controller: _titleController,
                  focusNode: _titleFocus,
                  submitted: _submitted,
                  l10n: l10n,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 24),
                DescriptionField(
                  controller: _descriptionController,
                  focusNode: _descriptionFocus,
                  l10n: l10n,
                ),
                const SizedBox(height: 28),
                PhotoSection(
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
