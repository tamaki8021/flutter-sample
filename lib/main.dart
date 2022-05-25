import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_demo_firebase/firebase_options.dart';
import 'package:flutter_demo_firebase/roomList_page.dart';
import 'package:flutter_demo_firebase/login_page.dart';
import 'package:flutter_demo_firebase/userState.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // firebaseの初期化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // ユーザーの情報を管理するデータ
  final UserState userState = UserState();

  @override
  Widget build(BuildContext context) {
    //子Widgetにデータを渡す
    return ChangeNotifierProvider<UserState>(
      create: (context) => UserState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: _LoginCheck(),
      ),
    );
  }
}

class _LoginCheck extends StatelessWidget {
  const _LoginCheck({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ログイン状態に応じて、画面を切り替える
    // ユーザー情報を受け取る
    final UserState userState = Provider.of<UserState>(context);
    final User? user = userState.user;

    return user != null ? RoomListPage() : LoginPage();
  }
}
