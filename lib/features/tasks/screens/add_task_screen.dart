import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../app/theme.dart';
import '../models/task_model.dart';
import '../providers/task_providers.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _priority = 'medium';
  DateTime? _dueDate;
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
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppTheme.primary,
              onSurface: AppTheme.onSurface,
              surface: AppTheme.surface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final taskTitle = _titleController.text.trim();
      final taskPriority = _priority;

      final repo = ref.read(taskRepositoryProvider);
      final task = TaskModel(
        courseId: _courseId,
        title: taskTitle,
        description: _descController.text.trim().isEmpty
            ? null
            : _descController.text.trim(),
        dueDate: _dueDate?.toIso8601String(),
        priority: taskPriority,
        isCompleted: false,
        createdAt: DateTime.now().toIso8601String(),
      );
      await repo.insertTask(task);
      ref.invalidate(taskListProvider(_courseId));

      // Navigate back to CourseDetailsScreen FIRST.
      Get.back();

      // Show success modal on top of CourseDetailsScreen.
      await Get.dialog<void>(
        _TaskCreatedDialog(title: taskTitle, priority: taskPriority),
        barrierDismissible: true,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        '❌ Error',
        'Failed to save task: $e',
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
        title: const Text('New Task'),
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
            const SizedBox(height: 8),
            _SectionLabel('Task Title', Icons.title_rounded),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(color: AppTheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'What do you need to study?',
                prefixIcon: Icon(Icons.task_alt_rounded, color: AppTheme.primary),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Task title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _SectionLabel('Description (optional)', Icons.description_rounded),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              maxLines: 3,
              style: const TextStyle(color: AppTheme.onSurface),
              decoration: const InputDecoration(
                hintText: 'Add more details...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes_rounded, color: AppTheme.primary),
              ),
            ),
            const SizedBox(height: 20),
            _SectionLabel('Priority', Icons.flag_rounded),
            const SizedBox(height: 8),
            _PrioritySelector(
              value: _priority,
              onChanged: (v) => setState(() => _priority = v),
            ),
            const SizedBox(height: 20),
            _SectionLabel('Due Date (optional)', Icons.calendar_today_rounded),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: const Border.fromBorderSide(
                    BorderSide(color: Color(0xFF2A2A45)),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.event_rounded, color: AppTheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      _dueDate == null
                          ? 'Tap to pick a due date'
                          : '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}',
                      style: TextStyle(
                        color: _dueDate == null
                            ? AppTheme.onSurfaceVariant
                            : AppTheme.onSurface,
                        fontSize: 15,
                      ),
                    ),
                    const Spacer(),
                    if (_dueDate != null)
                      GestureDetector(
                        onTap: () => setState(() => _dueDate = null),
                        child: const Icon(Icons.clear_rounded,
                            color: AppTheme.onSurfaceVariant, size: 20),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTask,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  final IconData icon;
  const _SectionLabel(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.primary),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppTheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _PrioritySelector extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _PrioritySelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const priorities = ['low', 'medium', 'high'];
    final colors = {
      'low': const Color(0xFF66BB6A),
      'medium': const Color(0xFFFFB300),
      'high': const Color(0xFFEF5350),
    };

    return Row(
      children: priorities.map((p) {
        final isSelected = value == p;
        final color = colors[p]!;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: GestureDetector(
              onTap: () => onChanged(p),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? color.withOpacity(0.2) : AppTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : const Color(0xFF2A2A45),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.flag_rounded, color: isSelected ? color : AppTheme.onSurfaceVariant, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      p[0].toUpperCase() + p.substring(1),
                      style: TextStyle(
                        color: isSelected ? color : AppTheme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Task Success Dialog ───────────────────────────────────────────────────────

class _TaskCreatedDialog extends StatelessWidget {
  final String title;
  final String priority;
  const _TaskCreatedDialog({required this.title, required this.priority});

  Color _priorityColor() {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF5350);
      case 'low':
        return const Color(0xFF66BB6A);
      default:
        return const Color(0xFFFFB300);
    }
  }

  IconData _priorityIcon() {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.keyboard_double_arrow_up_rounded;
      case 'low':
        return Icons.keyboard_double_arrow_down_rounded;
      default:
        return Icons.drag_handle_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pColor = _priorityColor();
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
            // Success icon
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
                border: Border.all(
                    color: AppTheme.primary.withOpacity(0.5), width: 2),
              ),
              child: const Icon(
                Icons.task_alt_rounded,
                color: AppTheme.secondary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Task Created! 🎯',
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            // Task title badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF2A2A45)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.notes_rounded,
                      size: 16, color: AppTheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Priority badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: pColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: pColor.withOpacity(0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_priorityIcon(), size: 14, color: pColor),
                  const SizedBox(width: 6),
                  Text(
                    '${priority[0].toUpperCase()}${priority.substring(1)} Priority',
                    style: TextStyle(
                      color: pColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your task has been saved.\nSwipe to mark it complete when done.',
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
