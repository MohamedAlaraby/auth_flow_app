import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/error/failures.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/email_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
// ignore: depend_on_referenced_packages
import 'package:gotrue/gotrue.dart' as gotrue;

class EmailAuthDataSourceImpl implements EmailAuthDataSource {
  final AuthClient _authClient;
  EmailAuthDataSourceImpl(this._authClient);
  @override
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _authClient.signUp(
        email: email,
        password: password,
        username: username,
      );
      if (response.user == null) {
        throw AuthException('The user is null'); // ← YOU throw this
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      // ← catches the one YOU threw above, passes it up unchanged
      rethrow;
    } on gotrue.AuthException catch (e) {
      throw AuthException(
        'Failed to sign up: ${e.message}',
      ); // map Supabase → yours
    } catch (e) {
      throw ServerException('Failed to sign up: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _authClient.signIn(
        email: email,
        password: password,
      );
      if (response.user == null) {
        // ← YOU throw this response.user;
        throw AuthException('The credentials are wrong');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign in: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
     return
      await _authClient.resetPassword(email: email);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to reset password: ${e.toString()}');
    }
  }
 
  @override
  Future<UserModel> verifyPasswordOtp({
    required String otp,
    required String email,
  }) async {
    try {
      final response = await _authClient.sendVerificationOnOtp(
        email: email,
        otp: otp,
      );
      if (response.user == null) {
        //The otp is wrong or expired
        throw AuthException('The otp is wrong or expired');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to verify email: ${e.toString()}');
    }
  }

  @override
  Future<void> updatePassword({required String password}) {
    try {
      return _authClient.updatePassword(password: password);
    } catch (e) {
      throw ServerException('Failed to update password: ${e.toString()}');
    }
  }

  @override
  Future<void> sendMagicLink({required String email}) async {
    try {
     
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send magic link: ${e.toString()}');
    }
  }
}
