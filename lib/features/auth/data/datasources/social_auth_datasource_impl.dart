import 'dart:developer';

import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:auth_flow_app/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final AuthClient _authClient;

  SocialAuthDataSourceImpl(this._authClient);
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  bool isInitialized = false;
  Future<void> ensureInitialized() async {
    if (isInitialized) return;
    await googleSignIn.initialize(
      serverClientId:
          '153047139207-amqehbo3m4k930o4ije22chba1hhl0b0.apps.googleusercontent.com',
    );
    isInitialized = true;
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      await ensureInitialized();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final String? idToken = googleUser.authentication.idToken;
      if (idToken == null) {
        throw AuthException('Google sign-in failed');
      }
      final authResponse = await _authClient.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );
      if (authResponse.user == null) {
        throw AuthException('Google sign-in failed');
      }
      log('user name is : ${authResponse.user!.userMetadata!['name']}');
      return UserModel.fromSupabaseUser(authResponse.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      log(e.toString());
      throw ServerException('Failed to sign in with Google: ${e.toString()}');
    }
  }

  @override
  Future<void> signInWithGitHub() async {
    try {
      final isLaunched = await _authClient.signInWithOAuthProvider(
        provider: OAuthProvider.github,
        //same as in android manifest and ios plist
        callbackUrl: 'com.elgendy.auth-flow-app://login-callback',
      );
      if (!isLaunched) {
        throw AuthException('Failed to launch sign in with GitHub');
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with GitHub: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithApple() async {
    try {
      // TODO: Implement signInWithApple
      throw UnimplementedError('signInWithApple not implemented yet');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with Apple: ${e.toString()}');
    }
  }
}
