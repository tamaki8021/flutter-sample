import 'package:flutter/material.dart';

class InputTextHistoryPage extends StatefulWidget {
  const InputTextHistoryPage({Key? key}) : super(key: key);

  @override
  State<InputTextHistoryPage> createState() => _InputTextHistoryPageState();
}

class _InputTextHistoryPageState extends State<InputTextHistoryPage> {
  final controller = TextEditingController();
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            // InputHistoryTextField(
            //   historyKey: "01",
            //   // lockItems: ['現在地', '大阪駅', 'React'],
            //   listStyle: ListStyle.Badge,
            //   showHistoryIcon: false,
            //   backgroundColor: Colors.lightBlue,
            //   textColor: Colors.white,
            //   deleteIconColor: Colors.white,
            //   onChanged: (value) {
            //     setState(() {
            //       message = value;
            //     });
            //   },
            // ),
            const SizedBox(
              height: 10,
            ),
            TextButton(
              onPressed: () {
                print(controller.text);
              },
              child: Text('button'),
            ),
          ],
        ),
      ),
    );
  }
}
