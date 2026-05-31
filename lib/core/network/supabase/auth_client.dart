import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthClient {
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  });
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  });

  Future<void> resetPassword({required String email});

  Future<AuthResponse> sendVerificationOnOtp({
    required String otp,
    required String email,
  });
  Future<void> updatePassword({required String password});
}
