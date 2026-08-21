import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../models/course_model.dart';
import '../providers/course_providers.dart';

class AddCourseScreen extends ConsumerStatefulWidget {
  const AddCourseScreen({super.key});

  @override
  ConsumerState<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends ConsumerState<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(courseRepositoryProvider);
      final courseName = _nameController.text.trim();
      final course = CourseModel(
        name: courseName,
        createdAt: DateTime.now().toIso8601String(),
      );
      await repo.insertCourse(course);
      ref.invalidate(courseListProvider);

      // Navigate home FIRST, then show the success modal on top of HomeScreen.
      Get.back();

      // Show success dialog on the now-active HomeScreen.
      await Get.dialog<void>(
        _CourseCreatedDialog(courseName: courseName),
        barrierDismissible: true,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        '❌ Error',
        'Failed to create course: $e',
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
        title: const Text('New Course'),
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
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.2),
                    AppTheme.primaryDark.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.book_outlined,
                      color: AppTheme.primary, size: 36),
                  const SizedBox(height: 12),
                  const Text(
                    'Create a Study Course',
                    style: TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Add a new subject or topic to organize your study plan.',
                    style: TextStyle(
                        color: AppTheme.onSurfaceVariant, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Course Name',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _saveCourse(),
              style: const TextStyle(color: AppTheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'e.g. Mathematics, Physics...',
                prefixIcon: Icon(Icons.school_outlined, color: AppTheme.primary),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a course name';
                }
                if (value.trim().length < 2) {
                  return 'Course name must be at least 2 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveCourse,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Save Course'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Success Dialog ────────────────────────────────────────────────────────────

class _CourseCreatedDialog extends StatelessWidget {
  final String courseName;
  const _CourseCreatedDialog({required this.courseName});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.15),
              blurRadius: 32,
              spreadRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary.withOpacity(0.3),
                    AppTheme.secondary.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: AppTheme.primary.withOpacity(0.5), width: 2),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppTheme.secondary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            // Title
            const Text(
              'Course Created! 🎉',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            // Course name badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school_rounded,
                      size: 16, color: AppTheme.primary),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      courseName,
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Subtitle
            const Text(
              'Your new course has been added.\nTap it to start adding tasks and notes.',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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
