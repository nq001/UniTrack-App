class TaskModel {
  final int? id;
  final int courseId;
  final String title;
  final String? description;
  final String? dueDate;
  final String priority;
  final bool isCompleted;
  final String createdAt;

  const TaskModel({
    this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.dueDate,
    required this.priority,
    this.isCompleted = false,
    required this.createdAt,
  });

  TaskModel copyWith({
    int? id,
    int? courseId,
    String? title,
    String? description,
    String? dueDate,
    String? priority,
    bool? isCompleted,
    String? createdAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as int?,
      courseId: map['course_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['due_date'] as String?,
      priority: map['priority'] as String? ?? 'medium',
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'course_id': courseId,
        'title': title,
        'description': description,
        'due_date': dueDate,
        'priority': priority,
        'is_completed': isCompleted,
        'created_at': createdAt,
      };

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int?,
      courseId: json['course_id'] as int? ?? 0,
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String?,
      dueDate: json['due_date'] as String?,
      priority: json['priority'] as String? ?? 'medium',
      isCompleted: json['is_completed'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? DateTime.now().toIso8601String(),
    );
  }

  @override
  String toString() =>
      'TaskModel(id: $id, courseId: $courseId, title: $title, isCompleted: $isCompleted)';
}
