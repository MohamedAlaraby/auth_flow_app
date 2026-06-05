import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthClientImpl implements AuthClient {
  final GoTrueClient client;
  final FunctionsClient functions;
  AuthClientImpl(this.client, this.functions);
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
  Future<void> signOut() async {
    return await client.signOut();
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
    return client.signInWithOAuth(provider, redirectTo: callbackUrl);
  }

  @override
  Future<void> sendOTP({required String mobile}) async {
    await client.signInWithOtp(channel: OtpChannel.sms, phone: mobile);
  }

  @override
  Future<AuthResponse> verifyOTP({
    required String mobile,
    required String otp,
  }) async {
    return await client.verifyOTP(type: OtpType.sms, phone: mobile, token: otp);
  }

  //User session
  @override
  User? get getCurrentUser {
    return client.currentUser;
  }

  @override
  Stream<AuthState> get onAuthStateChanged {
    //Receive a notification every time an auth event happens.
    return client.onAuthStateChange;
  }

  @override
  Future<UserResponse> updateUserData({
    required UserAttributes userAttributes,
  }) async {
    return await client.updateUser(userAttributes);
  }

  @override
  Future<void> deleteUser() async {
    await functions.invoke('delete-user');
    await client.signOut(scope: SignOutScope.global);
  }
}
