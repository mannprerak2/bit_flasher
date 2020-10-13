import 'package:bit_flasher/global.dart';
import 'package:bit_flasher/screens/receiver.dart';
import 'package:bit_flasher/screens/sender.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashState()),
        ChangeNotifierProvider(create: (_) => BitMode()),
        ChangeNotifierProvider(create: (_) => FlashDuration()),
      ],
      child: MaterialApp(
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Consumer<FlashDuration>(
                      builder: (_, fl, __) {
                        return RawMaterialButton(
                          onPressed: () {
                            showDialog<int>(
                              context: _,
                              builder: (_) => NumberPickerDialog.integer(
                                  minValue: 10,
                                  maxValue: 500,
                                  step: 5,
                                  initialIntegerValue: fl.millisec),
                            ).then((value) {
                              if (value != null) fl.setDuration(value);
                            });
                          },
                          fillColor: Colors.white,
                          child: Text(fl.millisec.toString()),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        );
                      },
                    ),
                    makeButton(v: CurrentView.sender, child: Text("Send")),
                    makeButton(v: CurrentView.receiver, child: Text("Receive")),
                    Consumer<BitMode>(
                      builder: (_, bm, __) {
                        return RawMaterialButton(
                          onPressed: () {
                            bm.changeMode();
                          },
                          fillColor: Colors.white,
                          child: Text(bm.mode.toString().split('.').last),
                          padding: EdgeInsets.all(15.0),
                          shape: CircleBorder(),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
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
        textColor: Colors.white,
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
