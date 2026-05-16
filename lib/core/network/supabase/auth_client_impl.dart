import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientImpl implements AuthClient {
  final GoTrueClient client;
  AuthClientImpl(this.client);
  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
   return await client.signUp(email: email, password: email);
  }
}
