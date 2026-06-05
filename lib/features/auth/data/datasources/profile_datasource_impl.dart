import 'dart:io';

import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/core/network/supabase/storage_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/profile_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show FileOptions, UserAttributes;

class ProfileDataSourceImpl implements ProfileDataSource {
  final AuthClient _authClient;
  final StorageClient _storageClient;
  ProfileDataSourceImpl(this._authClient, this._storageClient);

  @override
  Future<UserModel> updateProfile({
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      final Map<String, dynamic>? userMetadata =
          _authClient.getCurrentUser?.userMetadata;
      if (userMetadata == null) {
        throw AuthException('The user is null');
      }
      final userAttributes = UserAttributes(
        data: {
          ...userMetadata,
          'name': displayName ?? userMetadata['name'],
          'avatar_url': photoUrl ?? userMetadata['avatar_url'],
        },
      );
      final response = await _authClient.updateUserData(
        userAttributes: userAttributes,
      );
      // final updatedUser=response.user ?? throw AuthException('The user is null');
      if (response.user == null) {
        throw AuthException('The user is null');
      } else {
        return UserModel.fromSupabaseUser(response.user!);
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to update profile: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture({required String filePath}) async {
    try {
      final userId = _authClient.getCurrentUser?.id ?? '';
      const bucketName = 'Avatars';
      final fileExt = filePath.split('.').last;
      final fullPathToFile = '$userId/avatar.$fileExt';
      final File file = File(filePath);
      await _storageClient.uploadFile(
        filePath: fullPathToFile,
        file: file,
        bucketName: 'Avatars',
        options: const FileOptions(upsert: true),
      );
      final photoUrl = await _storageClient.getPublicUrl(
        bucketName: bucketName,
        filePath: fullPathToFile,
      );
      if (photoUrl.isEmpty) {
        throw ServerException('The url is empty');
      }
      await updateProfile(photoUrl: photoUrl);
      return photoUrl;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(
        'Failed to upload profile picture: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _authClient.deleteUser();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to delete account: ${e.toString()}');
    }
  }
}
