import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import '../../../app/routes.dart';
import '../../../app/theme.dart';
import '../../../core/services/api_service.dart';
import '../../courses/models/course_model.dart';
import '../../courses/providers/course_providers.dart';
import '../../notes/models/note_model.dart';
import '../../notes/providers/note_providers.dart';
import '../models/task_model.dart';
import '../providers/task_providers.dart';

// Filter enum
enum TaskFilter { all, pending, completed }

class CourseDetailsScreen extends ConsumerStatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  ConsumerState<CourseDetailsScreen> createState() =>
      _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends ConsumerState<CourseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late CourseModel _course;
  TaskFilter _filter = TaskFilter.all;
  bool _isImporting = false;

  @override
  void initState() {
    super.initState();
    // Cache course immediately — Get.arguments is cleared after Get.back(),
    // so reading it lazily in a getter causes a cast crash during pop animation.
    _course = Get.arguments as CourseModel;
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  CourseModel get course => _course;

  List<TaskModel> _filteredTasks(List<TaskModel> tasks) {
    switch (_filter) {
      case TaskFilter.all:
        return tasks;
      case TaskFilter.pending:
        return tasks.where((t) => !t.isCompleted).toList();
      case TaskFilter.completed:
        return tasks.where((t) => t.isCompleted).toList();
    }
  }

  Future<void> _importSampleTasks() async {
    setState(() => _isImporting = true);
    try {
      final apiService = ApiService();
      final tasks = await apiService.fetchSampleTasks(course.id!);
      final taskRepo = ref.read(taskRepositoryProvider);
      await taskRepo.insertMany(tasks);
      ref.invalidate(taskListProvider(course.id!));
      Get.snackbar(
        '✅ Imported',
        'Sample tasks imported successfully.',
        backgroundColor: AppTheme.surface,
        colorText: AppTheme.onSurface,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      Get.snackbar(
        '❌ Import Failed',
        e.toString(),
        backgroundColor: AppTheme.error.withOpacity(0.2),
        colorText: AppTheme.error,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  Future<void> _deleteCourse() async {
    // Capture course data before any async operation or navigation
    final courseToDelete = _course;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Course',
            style: TextStyle(color: AppTheme.onSurface)),
        content: Text(
          'Delete "${courseToDelete.name}"? All tasks and notes will also be deleted.',
          style: const TextStyle(color: AppTheme.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(color: AppTheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete',
                style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!mounted) return;

    try {
      final repo = ref.read(courseRepositoryProvider);
      await repo.deleteCourse(courseToDelete.id!);

      // Navigate back BEFORE invalidating so the screen is fully gone
      // before Riverpod triggers any rebuild on this (now popped) widget.
      Get.back();

      // Invalidate after navigation so HomeScreen refreshes its list.
      ref.invalidate(courseListProvider);

      Get.snackbar(
        '🗑️ Deleted',
        '"${courseToDelete.name}" has been removed.',
        backgroundColor: AppTheme.surface,
        colorText: AppTheme.onSurface,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } catch (e) {
      if (!mounted) return;
      Get.snackbar(
        '❌ Error',
        'Failed to delete course: $e',
        backgroundColor: AppTheme.error.withOpacity(0.2),
        colorText: AppTheme.error,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(taskListProvider(course.id!));
    final notesAsync = ref.watch(noteListProvider(course.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          course.name,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: _isImporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: AppTheme.primary,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.download_rounded),
            tooltip: 'Import Sample Tasks',
            onPressed: _isImporting ? null : _importSampleTasks,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: AppTheme.error),
            tooltip: 'Delete Course',
            onPressed: _deleteCourse,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.onSurfaceVariant,
          indicatorColor: AppTheme.primary,
          indicatorSize: TabBarIndicatorSize.tab,
          tabs: const [
            Tab(icon: Icon(Icons.task_alt_rounded), text: 'Tasks'),
            Tab(icon: Icon(Icons.sticky_note_2_rounded), text: 'Notes'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tasks Tab
          tasksAsync.when(
            data: (tasks) => _TasksTab(
              tasks: _filteredTasks(tasks),
              allTasks: tasks,
              filter: _filter,
              courseId: course.id!,
              onFilterChanged: (f) => setState(() => _filter = f),
              onTaskToggle: (task) async {
                final repo = ref.read(taskRepositoryProvider);
                await repo.toggleTaskCompletion(task.id!, !task.isCompleted);
                ref.invalidate(taskListProvider(course.id!));
              },
              onTaskDelete: (task) async {
                final repo = ref.read(taskRepositoryProvider);
                await repo.deleteTask(task.id!);
                ref.invalidate(taskListProvider(course.id!));
                Get.snackbar(
                  '🗑️ Task Deleted',
                  '"${task.title}" removed.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  backgroundColor: AppTheme.surface,
                  colorText: AppTheme.onSurface,
                );
              },
            ),
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primary)),
            error: (e, _) => Center(
              child: Text('Error: $e',
                  style: const TextStyle(color: AppTheme.error)),
            ),
          ),
          // Notes Tab
          notesAsync.when(
            data: (notes) => _NotesTab(
              notes: notes,
              courseId: course.id!,
              onNoteDelete: (note) async {
                final repo = ref.read(noteRepositoryProvider);
                await repo.deleteNote(note.id!);
                ref.invalidate(noteListProvider(course.id!));
                Get.snackbar(
                  '🗑️ Note Deleted',
                  '"${note.title}" removed.',
                  snackPosition: SnackPosition.BOTTOM,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  backgroundColor: AppTheme.surface,
                  colorText: AppTheme.onSurface,
                );
              },
            ),
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primary)),
            error: (e, _) => Center(
              child: Text('Error: $e',
                  style: const TextStyle(color: AppTheme.error)),
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                await Get.toNamed(AppRoutes.addTask, arguments: course.id);
                ref.invalidate(taskListProvider(course.id!));
              },
              icon: const Icon(Icons.add_task_rounded),
              label: const Text('Add Task'),
            )
          : FloatingActionButton.extended(
              onPressed: () async {
                await Get.toNamed(AppRoutes.addNote, arguments: course.id);
                ref.invalidate(noteListProvider(course.id!));
              },
              icon: const Icon(Icons.note_add_rounded),
              label: const Text('Add Note'),
            ),
    );
  }
}

class _TasksTab extends StatefulWidget {
  final List<TaskModel> tasks;
  final List<TaskModel> allTasks;
  final TaskFilter filter;
  final int courseId;
  final ValueChanged<TaskFilter> onFilterChanged;
  final ValueChanged<TaskModel> onTaskToggle;
  final ValueChanged<TaskModel> onTaskDelete;

  const _TasksTab({
    required this.tasks,
    required this.allTasks,
    required this.filter,
    required this.courseId,
    required this.onFilterChanged,
    required this.onTaskToggle,
    required this.onTaskDelete,
  });

  @override
  State<_TasksTab> createState() => _TasksTabState();
}

class _TasksTabState extends State<_TasksTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter buttons
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Row(
            children: TaskFilter.values.map((f) {
              final isSelected = widget.filter == f;
              final label = f.name[0].toUpperCase() + f.name.substring(1);
              final count = f == TaskFilter.all
                  ? widget.allTasks.length
                  : f == TaskFilter.pending
                      ? widget.allTasks.where((t) => !t.isCompleted).length
                      : widget.allTasks.where((t) => t.isCompleted).length;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppTheme.primary
                            : AppTheme.surfaceVariant,
                        foregroundColor: isSelected
                            ? Colors.white
                            : AppTheme.onSurfaceVariant,
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primary
                              : const Color(0xFF2A2A45),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      onPressed: () => widget.onFilterChanged(f),
                      child: Text('$label ($count)', style: const TextStyle(fontSize: 12)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: widget.tasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task_alt_rounded,
                        size: 56,
                        color: AppTheme.onSurfaceVariant.withOpacity(0.4),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.filter == TaskFilter.all
                            ? 'No tasks yet'
                            : 'No ${widget.filter.name} tasks',
                        style: const TextStyle(
                          color: AppTheme.onSurfaceVariant,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 90),
                  itemCount: widget.tasks.length,
                  itemBuilder: (context, index) {
                    final task = widget.tasks[index];
                    return _TaskCard(
                      task: task,
                      onToggle: () => widget.onTaskToggle(task),
                      onDelete: () => widget.onTaskDelete(task),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF5350);
      case 'medium':
        return const Color(0xFFFFB300);
      case 'low':
        return const Color(0xFF66BB6A);
      default:
        return AppTheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pColor = _priorityColor(task.priority);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.isCompleted
                      ? AppTheme.secondary.withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.isCompleted
                        ? AppTheme.secondary
                        : AppTheme.onSurfaceVariant,
                    width: 2,
                  ),
                ),
                child: task.isCompleted
                    ? const Icon(Icons.check, size: 14, color: AppTheme.secondary)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.title,
                    style: TextStyle(
                      color: task.isCompleted
                          ? AppTheme.onSurfaceVariant
                          : AppTheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (task.description != null &&
                      task.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      task.description!,
                      style: TextStyle(
                        color: AppTheme.onSurfaceVariant
                            .withOpacity(task.isCompleted ? 0.5 : 1.0),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: pColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: pColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          task.priority.toUpperCase(),
                          style: TextStyle(
                            color: pColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (task.dueDate != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.calendar_today_rounded,
                            size: 12, color: AppTheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(task.dueDate!),
                          style: const TextStyle(
                            color: AppTheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.error, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _NotesTab extends StatelessWidget {
  final List<NoteModel> notes;
  final int courseId;
  final ValueChanged<NoteModel> onNoteDelete;

  const _NotesTab({
    required this.notes,
    required this.courseId,
    required this.onNoteDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sticky_note_2_outlined,
              size: 56,
              color: AppTheme.onSurfaceVariant.withOpacity(0.4),
            ),
            const SizedBox(height: 12),
            const Text(
              'No notes yet',
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 90),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return _NoteCard(note: note, onDelete: () => onNoteDelete(note));
      },
    );
  }
}

class _NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onDelete;

  const _NoteCard({required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      color: AppTheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: AppTheme.error, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.body,
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _formatDate(note.createdAt),
              style: const TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return iso;
    }
  }
}
