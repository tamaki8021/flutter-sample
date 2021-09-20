import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo_firebase/roomList_page.dart';
import 'package:flutter_demo_firebase/userState.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String infoText = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);

    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'メールアドレス'),
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'パスワード'),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.all(8),
                child: Text(infoText),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('ユーザー登録'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.createUserWithEmailAndPassword(
                          email: email, password: password);

                      // ユーザー情報を更新
                      userState.setUser(result.user!);

                      final uid = userState.user!.uid;
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .set({
                        'uid': uid,
                        'email': email,
                        'password': password,
                      });

                      // チャット画面に遷移
                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return RoomListPage();
                      }));
                    } catch (e) {
                      setState(() {
                        infoText = "登録に失敗しました: ${e.toString()}";
                      });
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('ログイン'),
                  onPressed: () async {
                    try {
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      final result = await auth.signInWithEmailAndPassword(
                          email: email, password: password);

                      userState.setUser(result.user!);

                      await Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) {
                        return RoomListPage();
                      }));
                    } catch (e) {
                      setState(() {
                        infoText = "ログインに失敗しました:${e.toString()}";
                      });
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
