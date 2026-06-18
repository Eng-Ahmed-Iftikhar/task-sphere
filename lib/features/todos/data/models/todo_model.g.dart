// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) => TodoModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  completed: json['completed'] as bool,
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: json['created_at'],
  updatedAt: json['updated_at'],
);

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'completed': instance.completed,
  'user': instance.user,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};
