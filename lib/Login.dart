import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

import 'Authstate.dart';
import 'logo_anim.dart';

late AuthState authState;




class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: 2250);
  static String? uid;
  final String apiKey = 'AIzaSyBEyGdYM-WwgTR0UcPTwfP3ff61f_CIwOY';

  Future<String?> _authUser(LoginData data) async {
    var exception = null;
    final loginUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey';
    final response = await http.post(Uri.parse(loginUrl),
        body: json.encode({
          'email': data.name,
          'password': data.password,
          'returnSecureToken': true,
        }));

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final String idToken = responseData['idToken'];
      final String refreshToken = responseData['refreshToken'];
      final String uid = responseData['localId'];
      setState(() {
        LoginScreenState.uid = uid;
      });

      // Perform further actions with the ID token and refresh token
      // e.g., save them locally, navigate to another screen, etc.
      authState.login();
      print('Logged in successfully!');
      print('ID Token: $idToken');
      print('uid: $uid');
      return null;
    } else {
      final String errorMessage = responseData['error']['message'];
      print('Login failed. Error: $errorMessage');
      exception = errorMessage;
      return exception;
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    var exception = null;
    final loginUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey';
    final response = await http.post(Uri.parse(loginUrl),
        body: json.encode({
          'email': data.name,
          'password': data.password,
          'returnSecureToken': true,
        }));

    final responseData = json.decode(response.body);

    if (response.statusCode == 200) {
      final String idToken = responseData['idToken'];
      final String refreshToken = responseData['refreshToken'];

      // Perform further actions with the ID token and refresh token
      // e.g., save them locally, navigate to another screen, etc.
      print('Logged in successfully!');
      print('ID Token: $idToken');
      print('Refresh Token: $refreshToken');
      return null;
    } else {
      final String errorMessage = responseData['error']['message'];
      print('Login failed. Error: $errorMessage');
      exception = errorMessage;
      return exception;
    }
  }

  Future<String> _recoverPassword(String name) async {
    final passwordRecoveryUrl =
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey';

    final response = await http.post(Uri.parse(passwordRecoveryUrl),
        body: json.encode({
          'email': name,
          'requestType': 'PASSWORD_RESET',
        }));

    if (response.statusCode == 200) {
      print('Password recovery email sent successfully!');
      return 'Password recovery email sent successfully!';
    } else {
      final responseData = json.decode(response.body);
      final String errorMessage = responseData['error']['message'];
      print('Password recovery failed. Error: $errorMessage');
      return 'Password recovery failed. Error: $errorMessage';
    }
  }

  @override
  Widget build(BuildContext context) {
    authState = Provider.of<AuthState>(context, listen: false);
    return FlutterLogin(
      title: 'System Automation and Integration Framework',
      logo: AssetImage('assets/images/creative.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {


      },
      onRecoverPassword: _recoverPassword,
    );
  }
  static String? getUid() {
    return uid;
  }

}



