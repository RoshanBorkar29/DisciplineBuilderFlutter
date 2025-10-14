import 'dart:convert'; // for jsonDecode
import 'package:flutter/material.dart';
import 'package:flutter_discplinebuilder/models/user.dart';

class UserProvider with ChangeNotifier {
  User _user = User(
    id: '',
    name: '',
    email: '',
    password: '',
    token: '',
    streak: 0,
    points: 0,
    league: 'Bronze',
  );

  User get user => _user;

  // ✅ Accepts a JSON string and decodes it
  void setUser(String userJson) {
    final userMap = jsonDecode(userJson) as Map<String, dynamic>;
    _user = User.fromJson(userMap);
    notifyListeners();
  }

  // ✅ Optional: allows setting directly from a User model
  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
  void clearUser(){
    _user=User(
        id: '',
      name: '',
      email: '',
      password: '', // Password field is typically excluded/ignored in provider state
      token: '',
      streak: 0,
      points: 0,
      league: 'Bronze',
    );
    notifyListeners();
  }
}
