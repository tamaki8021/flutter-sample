import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 更新可能なデータ
class UserState extends ChangeNotifier {
  User? user;

  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}
