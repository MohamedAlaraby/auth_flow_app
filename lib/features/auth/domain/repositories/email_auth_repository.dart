import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';

abstract class EmailAuthRepository {
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> resetPassword({required String email});

  Future<Either<Failure, void>> verifyEmail({required String token});

  Future<Either<Failure, void>> sendMagicLink({required String email});
}
