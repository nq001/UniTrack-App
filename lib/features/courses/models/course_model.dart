class CourseModel {
  final int? id;
  final String name;
  final String createdAt;

  const CourseModel({
    this.id,
    required this.name,
    required this.createdAt,
  });

  CourseModel copyWith({
    int? id,
    String? name,
    String? createdAt,
  }) {
    return CourseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'created_at': createdAt,
    };
  }

  factory CourseModel.fromMap(Map<String, dynamic> map) {
    return CourseModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      CourseModel.fromMap(json);

  @override
  String toString() =>
      'CourseModel(id: $id, name: $name, createdAt: $createdAt)';
}
