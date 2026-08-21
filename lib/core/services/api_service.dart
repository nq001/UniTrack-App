import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../features/tasks/models/task_model.dart';

class ApiService {
  static const String _baseUrl =
      'https://jsonplaceholder.typicode.com/todos?_limit=10';

  Future<List<TaskModel>> fetchSampleTasks(int courseId) async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList.map((item) {
        final map = item as Map<String, dynamic>;
        return TaskModel(
          courseId: courseId,
          title: map['title'] as String? ?? 'Sample Task',
          description: 'Imported from online sample tasks',
          dueDate: null,
          priority: 'medium',
          isCompleted: map['completed'] as bool? ?? false,
          createdAt: DateTime.now().toIso8601String(),
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch sample tasks: ${response.statusCode}');
    }
  }
}
