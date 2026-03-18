import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/session_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class SessionDataSourceImpl implements SessionDataSource {
  final AuthClient _authClient;

  SessionDataSourceImpl(this._authClient);

  @override
  UserModel? getCurrentUser() {
    try {
      final user = _authClient.getCurrentUser;

      return user != null ? UserModel.fromSupabaseUser(user) : null;
    } catch (e) {
      throw ServerException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // TODO: Implement signOut
      throw UnimplementedError('signOut not implemented yet');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    // TODO: Implement authStateChanges
    throw UnimplementedError('authStateChanges not implemented yet');
  }
}
