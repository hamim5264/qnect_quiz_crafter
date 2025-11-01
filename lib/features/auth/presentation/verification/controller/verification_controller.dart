import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/email_otp/email_otp_sender.dart';
import '../../../providers/temp_auth_providers.dart';

final verificationControllerProvider =
    NotifierProvider<VerificationController, VerificationState>(
      VerificationController.new,
    );

class VerificationState {
  final String code;
  final int secondsRemaining;
  final bool isVerifying;
  final bool canResend;
  final String maskedEmail;

  VerificationState({
    required this.code,
    required this.secondsRemaining,
    required this.isVerifying,
    required this.canResend,
    required this.maskedEmail,
  });

  VerificationState copyWith({
    String? code,
    int? secondsRemaining,
    bool? isVerifying,
    bool? canResend,
    String? maskedEmail,
  }) {
    return VerificationState(
      code: code ?? this.code,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isVerifying: isVerifying ?? this.isVerifying,
      canResend: canResend ?? this.canResend,
      maskedEmail: maskedEmail ?? this.maskedEmail,
    );
  }
}

class VerificationController extends Notifier<VerificationState> {
  Timer? _timer;
  late String _email;
  bool _initialized = false;

  @override
  VerificationState build() {
    ref.onDispose(() {
      _timer?.cancel();
    });

    return VerificationState(
      code: '',
      secondsRemaining: 120,
      isVerifying: false,
      canResend: false,
      maskedEmail: '',
    );
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    final masked =
        name.length <= 2 ? "${name[0]}*" : "${name.substring(0, 2)}***";
    return "$masked@$domain";
  }

  Future<void> initEmailVerification(String email) async {
    if (_initialized) return;
    _initialized = true;

    _email = email;
    state = state.copyWith(maskedEmail: _maskEmail(email));

    await _sendOtp();
    _startTimer();
  }

  void updateCode(String value) {
    state = state.copyWith(code: value);
  }

  void _startTimer() {
    _timer?.cancel();
    state = state.copyWith(secondsRemaining: 120, canResend: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (state.secondsRemaining <= 1) {
        t.cancel();
        state = state.copyWith(secondsRemaining: 0, canResend: true);
      } else {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      }
    });
  }

  Future<bool> _sendOtp() async {
    return await EmailOtpSender.sendOtpToEmail(
      userEmail: _email,
      userName: "User",
    );
  }

  Future<bool> verifyOtp() async {
    if (state.code.length != 4) return false;

    state = state.copyWith(isVerifying: true);
    final valid = await EmailOtpSender.verifyOtp(state.code);
    state = state.copyWith(isVerifying: false);

    if (!valid) return false;

    ref.read(tempEmailProvider.notifier).state = _email;
    return true;
  }

  Future<bool> resendOtp() async {
    if (!state.canResend) return false;

    final sent = await _sendOtp();
    _startTimer();
    return sent;
  }
}
