import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/task_model.dart';

class TaskRepository {
  Future<Database> get _db => AppDatabase.database;

  Future<List<TaskModel>> getTasksByCourse(int courseId) async {
    final db = await _db;
    final maps = await db.query(
      'tasks',
      where: 'course_id = ?',
      whereArgs: [courseId],
      orderBy: 'created_at DESC',
    );
    return maps.map(TaskModel.fromMap).toList();
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await _db;
    return db.insert('tasks', task.toMap());
  }

  Future<int> updateTask(TaskModel task) async {
    final db = await _db;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await _db;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> toggleTaskCompletion(int id, bool isCompleted) async {
    final db = await _db;
    return db.update(
      'tasks',
      {'is_completed': isCompleted ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMany(List<TaskModel> tasks) async {
    final db = await _db;
    final batch = db.batch();
    for (final task in tasks) {
      batch.insert('tasks', task.toMap());
    }
    await batch.commit(noResult: true);
  }
}
