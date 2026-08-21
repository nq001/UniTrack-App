import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../features/courses/data/course_repository.dart';
import '../../features/tasks/data/task_repository.dart';
import '../../features/notes/data/note_repository.dart';

class BackupService {
  final CourseRepository courseRepository;
  final TaskRepository taskRepository;
  final NoteRepository noteRepository;

  BackupService({
    required this.courseRepository,
    required this.taskRepository,
    required this.noteRepository,
  });

  Future<String> exportBackup() async {
    final courses = await courseRepository.getAllCourses();
    final allTasks = <Map<String, dynamic>>[];
    final allNotes = <Map<String, dynamic>>[];

    for (final course in courses) {
      if (course.id != null) {
        final tasks = await taskRepository.getTasksByCourse(course.id!);
        final notes = await noteRepository.getNotesByCourse(course.id!);
        allTasks.addAll(tasks.map((t) => t.toJson()));
        allNotes.addAll(notes.map((n) => n.toJson()));
      }
    }

    final backupData = {
      'exported_at': DateTime.now().toIso8601String(),
      'courses': courses.map((c) => c.toJson()).toList(),
      'tasks': allTasks,
      'notes': allNotes,
    };

    final docsDir = await getApplicationDocumentsDirectory();
    final filePath = p.join(docsDir.path, 'studysync_backup.json');
    final file = File(filePath);
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(backupData),
    );

    return filePath;
  }
}
