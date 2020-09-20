import 'package:flutter/material.dart';
import 'package:torch_compat/torch_compat.dart';

void main() {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  UiState uiState = UiState.none;

  void checkTorch() async {
    try {
      if (await TorchCompat.hasTorch) {
        setState(() {
          uiState = UiState.flashSupported;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        uiState = UiState.flashNotSupported;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    checkTorch();
  }

  @override
  Widget build(BuildContext context) {
    switch (uiState) {
      case UiState.flashNotSupported:
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text(
                "Flash not supported on Device",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        );
        break;
      case UiState.flashSupported:
        return MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      TorchCompat.turnOn();
                    },
                    icon: Icon(Icons.flash_on),
                  ),
                  IconButton(
                    onPressed: () {
                      TorchCompat.turnOff();
                    },
                    icon: Icon(Icons.flash_off),
                  ),
                ],
              ),
            ),
          ),
        );
      default:
        return Container(
          color: Colors.white,
        );
    }
  }

  @override
  void dispose() {
    TorchCompat.dispose();
    super.dispose();
  }
}

enum UiState {
  none,
  flashNotSupported,
  flashSupported,
}
