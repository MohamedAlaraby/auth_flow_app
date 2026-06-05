import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/session_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SessionDataSourceImpl implements SessionDataSource {
  final AuthClient _authClient;

  SessionDataSourceImpl(this._authClient);

  @override
  UserModel getCurrentUser() {
    try {
      final supabase.User? user = _authClient.getCurrentUser;
      if (user == null) {
        throw AuthException('The user is null');
      } else {
        return UserModel.fromSupabaseUser(user);
      }
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authClient.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _authClient.onAuthStateChanged.map((authState) {
      if (authState.session?.user == null) {
        return null;
      } else {
        return UserModel.fromSupabaseUser(authState.session!.user);
      }
    });
  }
  
}
