import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientImpl implements AuthClient {
  final GoTrueClient client;

  AuthClientImpl(this.client);

  @override
  Future<AuthResponse> signUp({required String email, required String password, required String name}) async {
    return await client.signUp(email: email, password: password, data: {'name': name});
  }

  @override
  Future<AuthResponse> signIn({required String email, required String password}) async {
    return await client.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> resetPasswordForEmail({required String email}) async {
    return await client.resetPasswordForEmail(email);
  }

  @override
  Future<AuthResponse> verifyPasswordResetOtp({required String email, required String otp}) async {
    return await client.verifyOTP(email: email, token: otp, type: OtpType.recovery);
  }

  @override
  Future<UserResponse> updatePassword({required String password}) async {
    return await client.updateUser(UserAttributes(password: password));
  }

  @override
  Future<AuthResponse> signInWithIdToken(OAuthProvider provider, String idToken) async {
    return await client.signInWithIdToken(provider: provider, idToken: idToken);
  }
}
