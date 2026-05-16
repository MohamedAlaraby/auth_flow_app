import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthClient {
  
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  });
}
