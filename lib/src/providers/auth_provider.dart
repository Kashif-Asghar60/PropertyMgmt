import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoggedIn = false;
  String _userId = '';
  bool _rememberMe = false;

  bool get isLoggedIn => _isLoggedIn;
  String get userId => _userId;
  bool get rememberMe => _rememberMe;

  late StreamController<bool> _initializationController;
  Stream<bool> get initializationStream => _initializationController.stream;

  AuthProvider() {
    _initializationController = StreamController<bool>.broadcast();
    _checkLoggedInStatus();
  }

  Future<void> _checkLoggedInStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _rememberMe = prefs.getBool('rememberMe') ?? false;

    if (_rememberMe) {
      final String email = prefs.getString('email') ?? '';
      final String password = prefs.getString('password') ?? '';

      try {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (userCredential.user != null) {
          _isLoggedIn = true;
          _userId = userCredential.user!.uid;
        }
      } catch (e) {
        print('Error checking login status: $e');
      }
    }
    _initializationController
        .add(true); // Notify that initialization is complete

    print('Remember Me: $_rememberMe');
    print('Is Logged In: $_isLoggedIn');
    print('User ID: $_userId');
    notifyListeners();
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Disable persistence on web platforms//
//await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
        _isLoggedIn = true;
        _userId = userCredential.user!.uid;
        _rememberMe = rememberMe;
        _saveRememberMeStatus(
            email, password, rememberMe); // Save the rememberMe status
      }
    } catch (e) {
      print('Login error: $e');
      throw e;
    }
    print('Remember Me: $rememberMe...$_rememberMe');
    print('Is Logged In: $_isLoggedIn');
    print('User ID: $_userId');
    notifyListeners();
  }

  Future<void> register(
      String email, String password, String name, String dob) async {
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Your custom registration logic here
        // Example: await _customRegistration(name, dob);

        _isLoggedIn = true;
        _userId = userCredential.user!.uid;
        _saveRememberMeStatus(email, password, false);
      }
    } catch (e) {
      print('Registration error: $e');
      throw e;
    }
    print('Remember Me: $_rememberMe');
    print('Is Logged In: $_isLoggedIn');
    print('User ID: $_userId');
    notifyListeners();
  }

  Future<void> _saveRememberMeStatus(
      String email, String password, bool rememberMe) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', rememberMe); // Save the rememberMe status
    if (rememberMe) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
    } else {
      await prefs.remove('email');
      await prefs.remove('password');
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _isLoggedIn = false;
      _userId = '';
      _rememberMe = false;

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('rememberMe');
      await prefs.remove('email');
      await prefs.remove('password');

      print('Remember Me: $_rememberMe');
      print('Is Logged In: $_isLoggedIn');
      print('User ID: $_userId');
    } catch (e) {
      print('Logout error: $e');
    }
    notifyListeners();
  }
}
