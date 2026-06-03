import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientImpl implements AuthClient {
  final GoTrueClient client;
  AuthClientImpl(this.client);
  @override
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    return await client.signUp(
      email: email,
      password: email,
      data: {'username': username},
    );
  }

  @override
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.signInWithPassword(email: email, password: password);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    return await client.resetPasswordForEmail(email);
  }

  @override
  Future<AuthResponse> sendVerificationOnOtp({
    required String otp,
    required String email,
  }) {
    return client.verifyOTP(type: OtpType.recovery, email: email, token: otp);
  }

  @override
  Future<UserResponse> updatePassword({required String password}) {
    return client.updateUser(UserAttributes(password: password));
  }

  @override
  Future<AuthResponse> signInWithIdToken({
    required OAuthProvider provider,
    required String idToken,
  }) {
    return client.signInWithIdToken(provider: provider, idToken: idToken);
  }

  @override
  Future<bool> signInWithOAuthProvider({
    required OAuthProvider provider,
    required String callbackUrl,
  }) {
    return client.signInWithOAuth( provider, redirectTo: callbackUrl);
  }
}
