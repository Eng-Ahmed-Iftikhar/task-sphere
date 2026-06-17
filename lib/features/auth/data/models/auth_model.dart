import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tasksphere/features/auth/data/models/user_model.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';

part 'auth_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AuthModel extends Equatable {
  final String accessToken;
  final String provider;
  final UserModel user;

  const AuthModel({
    required this.accessToken,
    required this.provider,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, provider, user];

  factory AuthModel.fromJson(Map<String, dynamic> json) =>
      _$AuthModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthModelToJson(this);

  factory AuthModel.fromEntity(AuthEntity entity) {
    return AuthModel(
      accessToken: entity.accessToken,
      provider: entity.provider,
      user: UserModel.fromEntity(entity.user),
    );
  }
}

extension AuthModelX on AuthModel {
  AuthEntity toEntity() {
    return AuthEntity(
      accessToken: accessToken,
      provider: provider,
      user: user.toEntity(),
    );
  }
}
