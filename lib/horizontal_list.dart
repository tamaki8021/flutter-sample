import 'package:flutter/material.dart';

class HorizontalList extends StatelessWidget {
  const HorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('おすすめ'),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, int index) => Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                        width: 130,
                        child: Image.network('https://picsum.photos/200')),
                    const Text('商品名'),
                    const Text('商品金額'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
