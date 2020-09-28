import 'package:flutter/material.dart';
import 'package:torch_compat/torch_compat.dart';

class SenderScreen extends StatefulWidget {
  @override
  _SenderScreenState createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  UiState uiState = UiState.none;
  bool flashOn = false;
  @override
  void initState() {
    super.initState();
    checkTorch();
  }

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
                  GestureDetector(
                    onTap: () {
                      if (flashOn) {
                        TorchCompat.turnOff();
                      } else {
                        TorchCompat.turnOn();
                      }
                      setState(() {
                        flashOn = !flashOn;
                      });
                    },
                    child: Transform.rotate(
                      angle: 0.5,
                      child: Icon(
                        Icons.flash_on_sharp,
                        size: 100,
                        color: flashOn ? Colors.yellow : Colors.grey[300],
                      ),
                    ),
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
