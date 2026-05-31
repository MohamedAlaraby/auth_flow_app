import 'package:auth_flow_app/features/auth/domain/repositories/email_auth_repository.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_event.dart';
import 'package:auth_flow_app/features/auth/presentation/bloc/email_auth/email_auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailAuthBloc extends Bloc<EmailAuthEvent, EmailAuthState> {
  final EmailAuthRepository emailAuthRepository;

  EmailAuthBloc({required this.emailAuthRepository})
    : super(const EmailAuthInitial()) {
    on<SignUpWithEmailEvent>(_onSignUpWithEmail);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    //============================
    on<ResetPasswordEvent>(_onResetPassword);
    on<VerifyOnPasswordOtpEvent>(_onVerifyOnPasswordOtp);
    on<UpdatePasswordEvent>(_onUpdatePassword);
    //============================
    on<SendMagicLinkEvent>(_onSendMagicLink);
  }

  Future<void> _onSignUpWithEmail(
    SignUpWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signUpWithEmail(
      email: event.email,
      password: event.password,
      username: event.username,
    );

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (user) => emit(EmailAuthSuccess(user: user)),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.resetPassword(email: event.email);
    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (_) => emit(
        ResetPasswordSendState(
          successMessage: 'Password reset email sent',
          email: event.email,
        ),
      ),
    );
  }

  Future<void> _onVerifyOnPasswordOtp(
    VerifyOnPasswordOtpEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.verifyOtpSendToEmail(
      email: event.email,
      otp: event.otp,
    );
    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (user) => emit(const VerifyPasswordOtpState()),
    );
  }

  Future<void> _onUpdatePassword(
    UpdatePasswordEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.updatePassword(
      password: event.password,
    );
    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (_) =>
          emit(const UpdatePasswordState(successMessage: 'Password updated')),
    );
  }

  //============================
  Future<void> _onSendMagicLink(
    SendMagicLinkEvent event,
    Emitter<EmailAuthState> emit,
  ) async {
    emit(const EmailAuthLoading());

    final result = await emailAuthRepository.sendMagicLink(email: event.email);

    result.fold(
      (failure) => emit(EmailAuthError(message: failure.message)),
      (_) => emit(const VerifyPasswordOtpState()),
    );
  }
}
