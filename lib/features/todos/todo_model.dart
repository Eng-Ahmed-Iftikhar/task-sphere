/// =======================
/// MODEL
/// =======================
class TodoModel {
  final int id;
  final String title;
  final String description;
  final bool completed;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
  });

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "completed": completed,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      completed: json["completed"],
    );
  }
}
