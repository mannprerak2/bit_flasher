import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:torch_compat/torch_compat.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  UiState uiState = UiState.none;
  CameraController controller;

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
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
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
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: CameraPreview(controller)),
                  ),
                  Row(
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
