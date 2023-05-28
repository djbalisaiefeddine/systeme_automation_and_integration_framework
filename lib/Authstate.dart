import 'package:flutter/foundation.dart';

class AuthState extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    // Perform the login logic
    // Set _isAuthenticated to true if login is successful
    _isAuthenticated = true;
    notifyListeners(); // Notify listeners about the state change
  }

  void logout() {
    // Perform the logout logic
    // Set _isAuthenticated to false
    _isAuthenticated = false;
    notifyListeners(); // Notify listeners about the state change
  }
}
