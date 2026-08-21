import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../models/note_model.dart';
import '../providers/note_providers.dart';

class AddNoteScreen extends ConsumerStatefulWidget {
  const AddNoteScreen({super.key});

  @override
  ConsumerState<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends ConsumerState<AddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isLoading = false;
  late int _courseId;

  @override
  void initState() {
    super.initState();
    // Cache immediately — Get.arguments is cleared on Get.back().
    _courseId = Get.arguments as int;
  }

  int get courseId => _courseId;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final noteTitle = _titleController.text.trim();

      final repo = ref.read(noteRepositoryProvider);
      final note = NoteModel(
        courseId: _courseId,
        title: noteTitle,
        body: _bodyController.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
      );
      await repo.insertNote(note);
      ref.invalidate(noteListProvider(_courseId));

      // Navigate back to CourseDetailsScreen FIRST.
      Get.back();

      // Show success modal on top of CourseDetailsScreen.
      await Get.dialog<void>(
        _NoteCreatedDialog(title: noteTitle),
        barrierDismissible: true,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        '❌ Error',
        'Failed to save note: $e',
        backgroundColor: AppTheme.error.withOpacity(0.2),
        colorText: AppTheme.error,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondary.withOpacity(0.15),
                    AppTheme.secondary.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.secondary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.sticky_note_2_rounded,
                        color: AppTheme.secondary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'New Study Note',
                          style: TextStyle(
                            color: AppTheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Capture your thoughts and key concepts.',
                          style: TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Note Title',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'Give your note a title...',
                prefixIcon: Icon(Icons.title_rounded, color: AppTheme.secondary),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Note title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Note Content',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bodyController,
              maxLines: 8,
              style: const TextStyle(
                color: AppTheme.onSurface,
                height: 1.6,
              ),
              decoration: const InputDecoration(
                hintText: 'Write your study notes here...',
                alignLabelWithHint: true,
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 120),
                  child: Icon(Icons.notes_rounded, color: AppTheme.secondary),
                ),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Note content is required';
                }
                if (v.trim().length < 3) {
                  return 'Note content is too short';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: Colors.black,
                ),
                onPressed: _isLoading ? null : _saveNote,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.black, strokeWidth: 2),
                      )
                    : const Text('Save Note'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Note Success Dialog ───────────────────────────────────────────────────

class _NoteCreatedDialog extends StatelessWidget {
  final String title;
  const _NoteCreatedDialog({required this.title});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color: AppTheme.secondary.withOpacity(0.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.secondary.withOpacity(0.12),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.secondary.withOpacity(0.3),
                    AppTheme.primary.withOpacity(0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                    color: AppTheme.secondary.withOpacity(0.5), width: 2),
              ),
              child: const Icon(
                Icons.sticky_note_2_rounded,
                color: AppTheme.secondary,
                size: 42,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Note Saved! 📝',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Note title badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppTheme.secondary.withOpacity(0.35)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.sticky_note_2_outlined,
                      size: 16, color: AppTheme.secondary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.secondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your note has been saved to this course.\nFind it anytime in the Notes tab.',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondary,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Get.back(),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
