import 'package:bit_flasher/global.dart';
import 'package:bit_flasher/screens/receiver.dart';
import 'package:bit_flasher/screens/sender.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

final global = Global();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  global.cameras = await availableCameras();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  CurrentView view = CurrentView.sender;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Builder(
                builder: (context) {
                  switch (view) {
                    case CurrentView.sender:
                      return SenderScreen();
                    case CurrentView.receiver:
                      return ReceiverScreen();
                  }
                  throw UnimplementedError();
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                makeButton(v: CurrentView.sender, child: Text("Send")),
                makeButton(v: CurrentView.receiver, child: Text("Receive"))
              ],
            )
          ],
        ),
      ),
    );
  }

  void changeView(CurrentView v) {
    setState(() {
      view = v;
    });
  }

  Widget makeButton({CurrentView v, Widget child}) {
    if (v == view) {
      return RaisedButton(
        color: Colors.blue,
        onPressed: () => changeView(v),
        child: child,
      );
    } else {
      return OutlineButton(
        onPressed: () => changeView(v),
        child: child,
      );
    }
  }
}

enum CurrentView { sender, receiver }
