import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:http/http.dart' as http;
import 'package:mandman/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  late String? _token;
  late DateTime? _expiryDate = DateTime.now();
  late String? _userId = '';
  String? _userName = '';
  late Timer? _authTimer = null;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<String> getCurrentUID() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final Map<String, dynamic> extractedData =
          json.decode(prefs.getString('userData').toString())
              as Map<String, dynamic>;

      _userId = extractedData['userId'];
      // _userName =extractedData['username'];
    }
    // print(_userId);
    return _userId.toString();
  }

//////////////////////////us e add to firestore when add your data from your profile
  Future<void> addToFireStore(String? useremail, String? fullname) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final Map<String, dynamic> extractedData =
          json.decode(prefs.getString('userData').toString())
              as Map<String, dynamic>;
      _userId = extractedData['userId'];
      // _userName =extractedData['username'];
      _userName = fullname;
    }
    // print(_userId);
    await FirebaseFirestore.instance.collection('users').doc(_userId).set({
      'username': _userName,
      'useremail': useremail,
    });

    String userName = json.encode({
      'userId': _userId,
      'username': _userName,
    });
    prefs.setString('userName', userName);
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDyrx6QaDX_JOPKnYpxZnas9csfPlytGYk';
    final uri=Uri.parse(url);
    try {
      final res = await http.post(uri,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(res.body);
      // print(responseData);
      // new Map<String, dynamic>.from(json.decode(res.body));
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      _autologout();
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      String userDAta = json.encode({
        'token': _token,
        'userId': _userId,
        // 'username': "$email" + "user",
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      prefs.setString('userData', userDAta);
    } catch (e) {
      throw e;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return _authenticate(email!, password!, 'signUp');
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email!, password!, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;

    final Map<String, dynamic> extractedData = json
        .decode(prefs.getString('userData').toString()) as Map<String, dynamic>;

    final expiryDate = DateTime.parse(extractedData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) return false;

    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expiryDate;

    notifyListeners();
    _autologout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autologout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
