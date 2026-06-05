import 'package:auth_flow_app/core/error/exceptions.dart';
import 'package:auth_flow_app/core/network/supabase/auth_client.dart';
import 'package:auth_flow_app/features/auth/data/datasources/phone_auth_datasource.dart';
import 'package:auth_flow_app/features/auth/data/models/user_model.dart';

class PhoneAuthDataSourceImpl implements PhoneAuthDataSource {
  final AuthClient _authClient;

  PhoneAuthDataSourceImpl(this._authClient);

  @override
  Future<void> sendOTP({required String phoneNumber}) async {
    try {
      await _authClient.sendOTP(mobile: phoneNumber);
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to send OTP: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  }) async {
    try {
      final response = await _authClient.verifyOTP(mobile: phoneNumber, otp: otpCode);
      if (response.user == null) {
        throw AuthException('The otp is wrong or expired');
      } else {
        return UserModel.fromSupabaseUser(response.user!);
      }
    } on AuthException {
      rethrow;
    } catch (e) {
      throw ServerException('Failed to verify OTP: ${e.toString()}');
    }
  }
}
