import 'package:flutter/material.dart';

enum AuthStep { credentials, otp }
enum LoginMethod { email, mobile }

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  AuthStep _step = AuthStep.credentials;
  LoginMethod _method = LoginMethod.email;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  AuthStep get step => _step;
  LoginMethod get method => _method;
  bool get isLoading => _isLoading;

  void setMethod(LoginMethod m) {
    _method = m;
    notifyListeners();
  }

  Future<void> sendOtp() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 1200));
    _isLoading = false;
    _step = AuthStep.otp;
    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    _isLoading = false;
    if (otp.length == 6) {
      _isLoggedIn = true;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  void goBack() {
    _step = AuthStep.credentials;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _step = AuthStep.credentials;
    notifyListeners();
  }
}
