import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/note_repository.dart';
import '../models/note_model.dart';

// Repository provider
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

// Note list provider (per course)
final noteListProvider =
    FutureProvider.family<List<NoteModel>, int>((ref, courseId) async {
  final repo = ref.watch(noteRepositoryProvider);
  return repo.getNotesByCourse(courseId);
});
