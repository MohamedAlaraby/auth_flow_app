import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthException;

class ProfileDataSourceImpl implements ProfileDataSource {
  final AuthClient _authClient;

  ProfileDataSourceImpl(this._authClient);

  @override
  Future<UserModel> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final currentMetaData = _authClient.getCurrentUser?.userMetadata;

      final updateMetaData = {
        ...currentMetaData ?? {},
        if (displayName != null) 'name': displayName,
        if (photoUrl != null) 'avatar_url': photoUrl,
      };

      final response = await _authClient.updateUser(UserAttributes(data: updateMetaData));

      if (response.user == null) {
        throw ServerException('Failed to update profile: User is null');
      }
      return UserModel.fromSupabaseUser(response.user!);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      // TODO: Implement uploadProfilePicture
      throw UnimplementedError('uploadProfilePicture not implemented yet');
    } catch (e) {
      throw ServerException('Failed to upload profile picture: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // TODO: Implement deleteAccount
      throw UnimplementedError('deleteAccount not implemented yet');
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete account: ${e.toString()}');
    }
  }
}
