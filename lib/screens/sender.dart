import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torch_compat/torch_compat.dart';
import 'package:bit_flasher/global.dart';

class SenderScreen extends StatefulWidget {
  @override
  _SenderScreenState createState() => _SenderScreenState();
}

class _SenderScreenState extends State<SenderScreen> {
  UiState uiState = UiState.none;
  final global = Global();

  @override
  void initState() {
    super.initState();
    checkTorch();
  }

  void checkTorch() async {
    try {
      if (await TorchCompat.hasTorch) {
        await TorchCompat.turnOff();
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
        return Scaffold(
          body: Center(
            child: Text(
              "Flash not supported on Device",
              style: TextStyle(fontSize: 20),
            ),
          ),
        );
        break;
      case UiState.flashSupported:
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: 0.5,
                  child: Consumer<FlashState>(
                    builder: (_, flash, child) => Icon(
                      Icons.flash_on_sharp,
                      size: 80,
                      color: flash.isOn ? Colors.yellow : Colors.grey[300],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: global.messageInput,
                    decoration: InputDecoration(
                      hintText: "Message",
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Colors.red[800],
                      textColor: Colors.white,
                      onPressed: () {
                        global.msender.stop();
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Stopping Transmission"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: Text("Stop"),
                    ),
                    OutlineButton(
                      child: Text("Clear"),
                      onPressed: global.messageInput.clear,
                    ),
                    RaisedButton(
                      color: Colors.green[800],
                      textColor: Colors.white,
                      child: Text("Transmit"),
                      onPressed: () {
                        global.msender.send(
                          global.messageInput.text,
                          Provider.of<FlashState>(context, listen: false),
                          Provider.of<BitMode>(context, listen: false).mode,
                          Provider.of<FlashDuration>(context, listen: false)
                              .millisec,
                        );
                      },
                    ),
                  ],
                ),
              ],
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
