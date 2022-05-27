import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_demo_firebase/input_text_history_page.dart';
import 'package:flutter_demo_firebase/search_bar.dart';
import 'package:flutter_demo_firebase/typeahead_page.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flutter_demo_firebase/addRoom_page.dart';
import 'package:flutter_demo_firebase/chat_page.dart';

class RoomListPage extends HookWidget {
  const RoomListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = useState<User?>(null);

    useEffect(() {
      final currentUser = FirebaseAuth.instance.currentUser;
      user.value = currentUser;
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await FlutterFireUIAuth.signOut(context: context);
              await Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return SignInScreen();
              }));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報:${user.value!.email}'),
          ),
          ElevatedButton(
            onPressed: () async {
              final data = {
                "uid": user.value!.uid,
                "createdAt": Timestamp.now(),
              };
              await FirebaseFirestore.instance
                  .collection('delete_users')
                  .add(data)
                  .then((value) async => {
                        await FirebaseAuth.instance.signOut(),
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) {
                          return SignInScreen();
                        }))
                      })
                  .catchError((e) => print("Failed to add user: $e"));
            },
            child: Text('退会する'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return InputTextHistoryPage();
                  },
                ),
              );
            },
            child: Text('ページ遷移1'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return TypeaheadPage();
                  },
                ),
              );
            },
            child: Text('ページ遷移2'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return SearchBarHintExample();
                  },
                ),
              );
            },
            child: Text('ページ遷移3'),
          ),
          Expanded(
              // Stream 非同期処理の結果を元にWidgetを作る
              child: StreamBuilder<QuerySnapshot>(
            // 投稿メッセージ一覧の取得
            stream: FirebaseFirestore.instance
                .collection('chat_room')
                .orderBy('createdAt')
                .snapshots(),
            builder: (context, snapshot) {
              // データが取得できた場合
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data!.docs;
                return ListView(
                  children: documents.map((document) {
                    return Card(
                      child: ListTile(
                        title: Text(document['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.input),
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return ChatPage(document['name']);
                                },
                              ),
                            );
                          },
                          // onPressed: () async {
                          //   await FirebaseFirestore.instance
                          //       .collection('chat_room')
                          //       .doc(document['name'])
                          //       .delete();
                          // },
                        ),
                      ),
                    );
                  }).toList(),
                );
              }
              // データが読込中の場合
              return Center(
                child: Text('読込中……'),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) {
            // return AddPostPage();
            return AddRoomPage();
          }));
        },
      ),
    );
  }
}
