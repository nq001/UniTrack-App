import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/note_model.dart';

class NoteRepository {
  Future<Database> get _db => AppDatabase.database;

  Future<List<NoteModel>> getNotesByCourse(int courseId) async {
    final db = await _db;
    final maps = await db.query(
      'notes',
      where: 'course_id = ?',
      whereArgs: [courseId],
      orderBy: 'created_at DESC',
    );
    return maps.map(NoteModel.fromMap).toList();
  }

  Future<int> insertNote(NoteModel note) async {
    final db = await _db;
    return db.insert('notes', note.toMap());
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await _db;
    return db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await _db;
    return db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
