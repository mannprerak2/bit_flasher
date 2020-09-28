import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../global.dart';

final global = Global();

class ReceiverScreen extends StatefulWidget {
  @override
  _ReceiverScreenState createState() => _ReceiverScreenState();
}

class _ReceiverScreenState extends State<ReceiverScreen> {
  CameraController controller;
  CameraState view = CameraState.none;
  @override
  void initState() {
    super.initState();
    controller = CameraController(global.cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      view = CameraState.init;
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (view) {
      case CameraState.none:
        return Center(child: CircularProgressIndicator());
        break;
      case CameraState.init:
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
            Text("Decoded Message Stream Here.."),
          ],
        );
    }
    throw UnimplementedError();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

enum CameraState { none, init }
