import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 更新可能なデータ
class UserState extends ChangeNotifier {
  UserState() : super() {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription =
        FirebaseAuth.instance.authStateChanges().listen(
      (data) {
        if (data == null) {
          user = data;
        } else {
          user = data;
        }
      },
    );
  }

  StreamSubscription<User?>? _authStateChangesSubscription;

  User? user;
  void setUser(User newUser) {
    user = newUser;
    notifyListeners();
  }
}
