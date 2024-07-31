import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String? _userId;
  String? _username;
  String? _nickname;

  String? get userId => _userId;
  String? get username => _username;
  String? get nickname => _nickname;

  void setUser(String id, String name, String nickname) {
    _userId = id;
    _username = name;
    _nickname = nickname;
    notifyListeners();
  }

  void clearUser() {
    _userId = null;
    _username = null;
    _nickname = null;
    notifyListeners();
  }
}
