import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasksphere/features/auth/data/models/user_model.dart';
import 'package:tasksphere/features/todos/domain/entities/todo_entity.dart';

part 'todo_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TodoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final UserModel user;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.completed,
    required this.user,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    completed,
    user,
    createdAt,
    updatedAt,
  ];

  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  // Factory constructor to convert UserEntity to UserModel
  factory TodoModel.fromEntity(TodoEntity entity) {
    return TodoModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      user: UserModel.fromEntity(entity.user),
      completed: entity.completed,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

// Extension to convert UserModel to UserEntity
extension TodoModelX on TodoModel {
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      description: description,
      user: user.toEntity(),
      completed: completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
