import 'package:tasksphere/features/auth/domain/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? imgUrl;
  final String? phone;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imgUrl,
    this.phone,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    imgUrl,
    phone,
    createdAt,
    updatedAt,
  ];

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Factory constructor to convert UserEntity to UserModel
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      imgUrl: entity.imgUrl,
      phone: entity.phone,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

// Extension to convert UserModel to UserEntity
extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      imgUrl: imgUrl,
      phone: phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
