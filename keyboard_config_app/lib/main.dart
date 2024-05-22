import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart' as window_size;
import 'dart:io' show Platform;

void main() {
  runApp(MyApp());
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    window_size.getWindowInfo().then((window) {
      if (window.screen != null) {
        final frame = window.screen!.visibleFrame;
        final width = 960.0;
        final height = 720.0;
        final left = ((frame.width - width) / 2).roundToDouble();
        final top = ((frame.height - height) / 3).roundToDouble();
        final newFrame = Rect.fromLTWH(left, top, width, height);
        window_size.setWindowFrame(newFrame);
        window_size.setWindowMinSize(Size(width, height));
        window_size.setWindowMaxSize(Size(width, height));
      }
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 20, 20, 30),
        body: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 960, height: 720),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      KeyboardDisplay(),
                      Expanded(child: KeyDetails()),
                    ],
                  ),
                ),
                GenerateButton(offset: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardDisplay extends StatefulWidget {
  @override
  _KeyboardDisplayState createState() => _KeyboardDisplayState();
}

class _KeyboardDisplayState extends State<KeyboardDisplay> {
  bool _isKeySelected = false; // Tracks whether the key has been pressed

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      width: 668, // Adjusted to the correct size of your keyboard layout
      height: 488,
      child: Stack(
        children: [
          Image.asset('assets/keyboardv3.png',
              width: 650,
              height: 470,
              fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
            return Text("Failed to load image!");
          }),
          Positioned(
            left: 81, // Adjust to position over the desired key
            top: 81,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isKeySelected = !_isKeySelected; // Toggle the key selection
                });
              },
              child: Stack(
                children: [
                  Image.asset(
                    'assets/key.png',
                    width: 66,
                    height: 66,
                    fit: BoxFit.fill,
                  ),
                  if (_isKeySelected) // Overlay image if the key is selected
                    Positioned.fill(
                      child: Image.asset(
                        'assets/keyhi.png', // Assuming you have a "key_selected.png"
                        fit: BoxFit.fill,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KeyDetails extends StatefulWidget {
  @override
  _KeyDetailsState createState() => _KeyDetailsState();
}

class _KeyDetailsState extends State<KeyDetails> {
  String? selectedKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: selectedKey == null
          ? Text("No Key Selected",
              style: TextStyle(fontFamily: 'Dogica', color: Colors.white))
          : Column(
              children: [
                Text("$selectedKey Selected",
                    style:
                        TextStyle(fontFamily: 'Dogica', color: Colors.white)),
                TextField(
                  decoration: InputDecoration(labelText: 'Macro'),
                  style: TextStyle(fontFamily: 'Dogica', color: Colors.white),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Name'),
                  style: TextStyle(fontFamily: 'Dogica', color: Colors.white),
                ),
              ],
            ),
    );
  }

  void selectKey(String key) {
    setState(() {
      selectedKey = key;
    });
  }
}

class GenerateButton extends StatelessWidget {
  final double offset;

  GenerateButton({this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: offset),
      child: Container(
        width: 200,
        child: Column(
          children: [
            Image.asset('assets/saveicon.png',
                errorBuilder: (context, error, stackTrace) {
              return Text("Failed to load image!");
            }),
            TextButton(
              onPressed: () {
                print('Generate JSON');
              },
              child: Text('Generate',
                  style: TextStyle(fontFamily: 'Dogica', color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
