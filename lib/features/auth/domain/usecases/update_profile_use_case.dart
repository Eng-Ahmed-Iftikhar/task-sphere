import 'package:image_picker/image_picker.dart';
import 'package:tasksphere/core/error/failures.dart';
import 'package:tasksphere/features/auth/domain/entities/auth_entity.dart';
import 'package:tasksphere/features/auth/domain/repositories/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UpdateProfileUseCase {
  final AuthRepository _repository;

  UpdateProfileUseCase(this._repository);

  Future<Either<Failure, AuthEntity>> execute({
    String? name,
    String? email,
    XFile? img,
  }) {
    return _repository.updateProfile(name: name, email: email, img: img);
  }
}
