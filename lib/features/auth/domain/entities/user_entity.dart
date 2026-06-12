import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? imgUrl;
  final String? phone;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  const UserEntity({
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
    phone,
    imgUrl,
    createdAt,
    updatedAt,
  ];

  // Factory constructor to create an empty user
  factory UserEntity.empty() {
    return const UserEntity(id: '', name: '', email: '', imgUrl: '', phone: '');
  }

  // CopyWith method for creating a new instance with some updated properties
  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? imgUrl,
    String? phone,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      imgUrl: imgUrl ?? this.imgUrl,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Method to check if user is empty
  bool get isEmpty => id.isEmpty && name.isEmpty && email.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
