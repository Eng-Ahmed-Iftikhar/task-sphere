import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:tasksphere/features/auth/domain/entities/user_entity.dart';

class TodoEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final UserEntity user;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const TodoEntity({
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

  // Factory constructor to create an empty user
  factory TodoEntity.empty() {
    return TodoEntity(
      id: '',
      title: '',
      description: '',
      completed: false,
      user: UserEntity.empty(),
    );
  }

  // CopyWith method for creating a new instance with some updated properties
  TodoEntity copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    UserEntity? user,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return TodoEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Method to check if user is empty
  bool get isEmpty => id.isEmpty && title.isEmpty && description.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
