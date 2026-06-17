import 'package:tasksphere/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String accessToken;
  final String provider;
  final UserEntity user;

  const AuthEntity({
    required this.accessToken,
    required this.provider,
    required this.user,
  });

  @override
  List<Object?> get props => [accessToken, provider, user];

  // Factory constructor to create an empty user
  factory AuthEntity.empty() {
    return AuthEntity(accessToken: '', provider: '', user: UserEntity.empty());
  }

  // CopyWith method for creating a new instance with some updated properties
  AuthEntity copyWith({
    String? accessToken,
    String? provider,
    UserEntity? user,
  }) {
    return AuthEntity(
      accessToken: accessToken ?? this.accessToken,
      provider: provider ?? this.provider,
      user: user ?? this.user,
    );
  }

  // Method to check if user is empty
  bool get isEmpty => accessToken.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
