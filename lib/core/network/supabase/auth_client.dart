import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthClient {
  Future<AuthResponse> signUp({required String email, required String password, required String name});

  Future<AuthResponse> signIn({required String email, required String password});

  Future<void> resetPasswordForEmail({required String email});

  Future<AuthResponse> verifyPasswordResetOtp({required String email, required String otp});

  Future<UserResponse> updatePassword({required String password});
}
