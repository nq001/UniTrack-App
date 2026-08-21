import 'package:sqflite/sqflite.dart';
import '../../../core/database/app_database.dart';
import '../models/course_model.dart';

class CourseRepository {
  Future<Database> get _db => AppDatabase.database;

  Future<List<CourseModel>> getAllCourses() async {
    final db = await _db;
    final maps = await db.query('courses', orderBy: 'created_at DESC');
    return maps.map(CourseModel.fromMap).toList();
  }

  Future<int> insertCourse(CourseModel course) async {
    final db = await _db;
    return db.insert('courses', course.toMap());
  }

  Future<int> updateCourse(CourseModel course) async {
    final db = await _db;
    return db.update(
      'courses',
      course.toMap(),
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(int id) async {
    final db = await _db;
    return db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }

  Future<CourseModel?> getCourseById(int id) async {
    final db = await _db;
    final maps = await db.query('courses', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return CourseModel.fromMap(maps.first);
  }
}
