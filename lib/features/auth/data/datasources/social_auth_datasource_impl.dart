import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:auth_flow_app/features/auth/data/datasources/social_auth_datasource.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';

class SocialAuthDataSourceImpl implements SocialAuthDataSource {
  final AuthClient _authClient;

  SocialAuthDataSourceImpl(this._authClient);

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // TODO: Implement signInWithGoogle
      throw UnimplementedError('signInWithGoogle not implemented yet');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with Google: ${e.toString()}');
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

  @override
  Future<UserModel> signInWithGitHub() async {
    try {
      // TODO: Implement signInWithGitHub
      throw UnimplementedError('signInWithGitHub not implemented yet');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in with GitHub: ${e.toString()}');
    }
  }
}