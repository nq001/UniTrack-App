import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/task_repository.dart';
import '../models/task_model.dart';

// Repository provider
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository();
});

// Task list provider (per course)
final taskListProvider =
    FutureProvider.family<List<TaskModel>, int>((ref, courseId) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTasksByCourse(courseId);
});
