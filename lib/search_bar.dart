import 'package:flutter/material.dart';

class SearchBarHintExample extends StatefulWidget {
  SearchBarHintExample({Key? key}) : super(key: key);

  @override
  _SearchBarHintExampleState createState() => _SearchBarHintExampleState();
}

class _SearchBarHintExampleState extends State<SearchBarHintExample> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            SearchBarWithHint(),
            const SizedBox(
              height: 64,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(32)),
                primary: Theme.of(context).primaryColor,
              ),
              child: Text('Remove Focus'),
              onPressed: () {
                FocusScope.of(context).unfocus();
              },
            )
          ],
        ),
      ),
    );
  }
}

class SearchBarWithHint extends StatefulWidget {
  @override
  _SearchBarWithHintState createState() => _SearchBarWithHintState();
}

class _SearchBarWithHintState extends State<SearchBarWithHint>
    with SingleTickerProviderStateMixin {
  final FocusNode searchNode = FocusNode();
  final TextEditingController searchController = new TextEditingController();

  bool isHintShown = false;
  late Offset textFieldPosition;
  late Size widgetSize;
  late OverlayEntry overlayEntry;
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    searchController.addListener(onTextInput);

    searchNode.addListener(() {
      if (searchNode.hasPrimaryFocus) {
        Future.delayed(const Duration(milliseconds: 300))
            .then((value) => showHint());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    searchNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  void onTextInput() {
    if (isHintShown) {
      closeHint();
    }
  }

  void closeHint() {
    overlayEntry.remove();
    // overlayEntry = null;
    isHintShown = false;
  }

  void showHint() {
    findParent();
    overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)!.insert(overlayEntry);
    isHintShown = true;
  }

  findParent() {
    RenderBox? renderBox = context.findRenderObject() as RenderBox;
    widgetSize = renderBox.size;
    textFieldPosition = renderBox.localToGlobal(Offset.zero);
  }

  OverlayEntry _overlayEntryBuilder() {
    return OverlayEntry(
      maintainState: true,
      builder: (context) {
        return GestureDetector(
            onTap: () {
              if (isHintShown) {
                closeHint();
              }
            },
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: Stack(children: [
                  Positioned(
                    top: textFieldPosition.dy + 56,
                    left: 24,
                    right: 24,
                    child: Material(
                      color: Colors.transparent,
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipPath(
                                clipper: ArrowClipper(),
                                child: Container(
                                  width: 16,
                                  height: 16,
                                  color: Colors.grey.shade900,
                                ),
                              )),
                        ),
                        Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade900,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: Text(
                                    'Search for any super hero, just type a name like \'Batman\' ... ',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(color: Colors.white),
                                  ),
                                )))
                      ]),
                    ),
                  )
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: searchNode,
      controller: searchController,
      decoration: InputDecoration(
          hintText: 'Search ...',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide())),
    );
  }
}

class ArrowClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width / 2, size.height / 2);
    path.lineTo(size.width, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
