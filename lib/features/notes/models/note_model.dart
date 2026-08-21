class NoteModel {
  final int? id;
  final int courseId;
  final String title;
  final String body;
  final String createdAt;

  const NoteModel({
    this.id,
    required this.courseId,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  NoteModel copyWith({
    int? id,
    int? courseId,
    String? title,
    String? body,
    String? createdAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      title: title ?? this.title,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'course_id': courseId,
      'title': title,
      'body': body,
      'created_at': createdAt,
    };
  }

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as int?,
      courseId: map['course_id'] as int,
      title: map['title'] as String,
      body: map['body'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory NoteModel.fromJson(Map<String, dynamic> json) =>
      NoteModel.fromMap(json);

  @override
  String toString() =>
      'NoteModel(id: $id, courseId: $courseId, title: $title)';
}
