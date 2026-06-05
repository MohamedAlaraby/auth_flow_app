import 'dart:io';

import 'package:auth_flow_app/core/network/supabase/storage_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageClientImpl implements StorageClient {
  final SupabaseStorageClient _storageClient;
  StorageClientImpl(this._storageClient);
  @override
  Future<String> uploadFile({
    required String bucketName,
    required File file,
    required String filePath,
    required FileOptions options,
  }) async {
    return await _storageClient
        .from(bucketName)
        .upload(filePath, file, fileOptions: options);
  }

  @override
  Future<String> getPublicUrl({
    required String bucketName,
    required String filePath,
  }) async {
    return _storageClient.from(bucketName).getPublicUrl(filePath);
  }
}
