import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class EmailAuthDataSource {
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  });

  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  });

  Future<void> resetPassword({required String email});
  Future<UserModel> verifyPasswordOtp({required String otp, required String email});
  Future<void> updatePassword({ required String password});
  
  Future<void> sendMagicLink({required String email});
}
