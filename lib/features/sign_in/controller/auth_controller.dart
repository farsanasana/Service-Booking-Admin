import 'package:admin/features/auth.dart';
import 'package:flutter/material.dart';

class AuthModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
    final String predefinedEmail = "farsana@gmail.com";
  final String predefinedPassword = "sana7262";
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) async {
    try {
      await _authService.signIn(predefinedEmail, predefinedPassword);
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }

  void signOut() {
    _authService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }
}
