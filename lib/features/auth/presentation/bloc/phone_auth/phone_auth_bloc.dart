import 'package:auth_flow_app/features/auth/domain/repositories/phone_auth_repository.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/phone_auth/phone_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/phone_auth/phone_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneAuthBloc extends Bloc<PhoneAuthEvent, PhoneAuthState> {
  final PhoneAuthRepository phoneAuthRepository;

  PhoneAuthBloc({required this.phoneAuthRepository})
    : super(const PhoneAuthInitial()) {
    on<SendOTPEvent>(_onSendOTP);
    on<VerifyOTPEvent>(_onVerifyOTP);
  }

  Future<void> _onSendOTP(
    SendOTPEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(const PhoneAuthLoading());

    final result = await phoneAuthRepository.sendOTP(phoneNumber: event.phoneNumber);

    result.fold(
      (failure) => emit(PhoneAuthError(message: failure.message)),
      (_) => emit(OTPSent(phoneNumber: event.phoneNumber)),
    );
  }

  Future<void> _onVerifyOTP(
    VerifyOTPEvent event,
    Emitter<PhoneAuthState> emit,
  ) async {
    emit(const PhoneAuthLoading());

    final result = await phoneAuthRepository.verifyOTP(
      phoneNumber: event.phoneNumber,
      otpCode: event.otpCode,
    );

    result.fold(
      (failure) => emit(PhoneAuthError(message: failure.message)),
      (user) => emit(PhoneAuthSuccess(user: user)),
    );
  }

  
}
