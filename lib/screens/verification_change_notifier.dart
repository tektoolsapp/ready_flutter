import 'otp_response.dart';
import 'otp_service.dart';
import 'verification_exception.dart';
import 'package:flutter/cupertino.dart';

enum NotifierState { initial, loading, loaded }

class VerificationChangeNotifier extends ChangeNotifier {
  final _otpService = OneTimePasswordService();

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  void _setState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  VerificationException _exception;
  VerificationException get exception => _exception;
  void _setVerificationException(VerificationException exception) {
    _exception = exception;
  }

  OneTimePasswordResponse _otpResponse;
  OneTimePasswordResponse get otpResponse => _otpResponse;
  void _setOtpResponse(OneTimePasswordResponse otpResponse) {
    _otpResponse = otpResponse;
  }

  void getOneTimePassword(String phoneNumber) async {
    _setState(NotifierState.loading);
    try {
      final otpResponse = await _otpService.getOneTimePassword(phoneNumber);
      _setOtpResponse(otpResponse);
    } on VerificationException catch (f) {
      _setVerificationException(f);
    }
    _setState(NotifierState.loaded);
  }
}