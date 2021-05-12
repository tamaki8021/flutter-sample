import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPostPage extends StatefulWidget {

  AddPostPage(this.user);
  final User user;

  @override
  _AddPostPageState createState() => _AddPostPageState();


}

class _AddPostPageState extends State<AddPostPage> {

  String messageText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット投稿'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('投稿'),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();
                    final email = widget.user.email; //AddPostPageのデータを参照

                    await FirebaseFirestore.instance
                        .collection('posts')
                        .doc()
                        .set({
                      'text': messageText,
                      'email': email,
                      'date': date,
                    });
                    Navigator.of(context).pop();
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