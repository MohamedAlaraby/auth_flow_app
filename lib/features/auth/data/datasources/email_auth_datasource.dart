import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

abstract class EmailAuthDataSource {
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> resetPassword({required String email});

  Future<void> verifyEmail({required String token});

  Future<void> sendMagicLink({required String email});
}