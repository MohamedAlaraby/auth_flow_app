import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class StorageClient {
  Future<String> uploadFile({
    required String bucketName,
    required File file,
    required String filePath,
    required FileOptions options,
  });
  Future<String> getPublicUrl({
    required String bucketName,
    required String filePath,
  });
}
