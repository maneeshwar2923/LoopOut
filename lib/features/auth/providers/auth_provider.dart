import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

/// Phone auth state
enum PhoneAuthStatus {
  initial,
  codeSent,
  verifying,
  verified,
  error,
}

/// Phone auth state class
class PhoneAuthState {
  final PhoneAuthStatus status;
  final String? verificationId;
  final String? errorMessage;
  final int? resendToken;

  const PhoneAuthState({
    this.status = PhoneAuthStatus.initial,
    this.verificationId,
    this.errorMessage,
    this.resendToken,
  });

  PhoneAuthState copyWith({
    PhoneAuthStatus? status,
    String? verificationId,
    String? errorMessage,
    int? resendToken,
  }) {
    return PhoneAuthState(
      status: status ?? this.status,
      verificationId: verificationId ?? this.verificationId,
      errorMessage: errorMessage ?? this.errorMessage,
      resendToken: resendToken ?? this.resendToken,
    );
  }
}

/// Phone authentication provider
@riverpod
class PhoneAuth extends _$PhoneAuth {
  @override
  PhoneAuthState build() {
    return const PhoneAuthState();
  }

  /// Start phone verification
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    state = const PhoneAuthState(status: PhoneAuthStatus.verifying);

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _onVerificationCompleted,
        verificationFailed: _onVerificationFailed,
        codeSent: _onCodeSent,
        codeAutoRetrievalTimeout: _onCodeAutoRetrievalTimeout,
        forceResendingToken: state.resendToken,
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      state = PhoneAuthState(
        status: PhoneAuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  /// Verify OTP code
  Future<bool> verifyOtp(String smsCode) async {
    if (state.verificationId == null) {
      state = const PhoneAuthState(
        status: PhoneAuthStatus.error,
        errorMessage: 'No verification ID found. Please try again.',
      );
      return false;
    }

    state = state.copyWith(status: PhoneAuthStatus.verifying);

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: state.verificationId!,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      state = state.copyWith(status: PhoneAuthStatus.verified);
      return true;
    } on FirebaseAuthException catch (e) {
      state = PhoneAuthState(
        status: PhoneAuthStatus.error,
        errorMessage: _getErrorMessage(e.code),
        verificationId: state.verificationId,
        resendToken: state.resendToken,
      );
      return false;
    } catch (e) {
      state = PhoneAuthState(
        status: PhoneAuthStatus.error,
        errorMessage: e.toString(),
        verificationId: state.verificationId,
        resendToken: state.resendToken,
      );
      return false;
    }
  }

  /// Resend OTP
  Future<void> resendOtp(String phoneNumber) async {
    await verifyPhoneNumber(phoneNumber);
  }

  /// Reset state
  void reset() {
    state = const PhoneAuthState();
  }

  // Callbacks
  void _onVerificationCompleted(PhoneAuthCredential credential) async {
    // Auto-verification (Android only)
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      state = state.copyWith(status: PhoneAuthStatus.verified);
    } catch (e) {
      state = PhoneAuthState(
        status: PhoneAuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void _onVerificationFailed(FirebaseAuthException e) {
    state = PhoneAuthState(
      status: PhoneAuthStatus.error,
      errorMessage: _getErrorMessage(e.code),
    );
  }

  void _onCodeSent(String verificationId, int? resendToken) {
    state = PhoneAuthState(
      status: PhoneAuthStatus.codeSent,
      verificationId: verificationId,
      resendToken: resendToken,
    );
  }

  void _onCodeAutoRetrievalTimeout(String verificationId) {
    // Just update verification ID, don't change status
    if (state.status == PhoneAuthStatus.verifying ||
        state.status == PhoneAuthStatus.initial) {
      state = state.copyWith(verificationId: verificationId);
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return 'The phone number is invalid. Please check and try again.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-verification-code':
        return 'The verification code is incorrect. Please try again.';
      case 'session-expired':
        return 'The verification session has expired. Please request a new code.';
      case 'quota-exceeded':
        return 'SMS quota exceeded. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Sign out provider
@riverpod
Future<void> signOut(Ref ref) async {
  await FirebaseAuth.instance.signOut();
}
