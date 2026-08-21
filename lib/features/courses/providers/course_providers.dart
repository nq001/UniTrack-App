import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/course_repository.dart';
import '../models/course_model.dart';

// Repository provider
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepository();
});

// Course list provider
final courseListProvider = FutureProvider<List<CourseModel>>((ref) async {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.getAllCourses();
});
