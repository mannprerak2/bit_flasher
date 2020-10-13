import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:torch_compat/torch_compat.dart';

import 'message_sender.dart';

class Global {
  List<CameraDescription> cameras;
  final messageInput = TextEditingController();
  final msender = MessageSender();

  // Singleton class.
  static final Global _global = Global._();
  factory Global() {
    return _global;
  }
  Global._();
}

class FlashState extends ChangeNotifier {
  bool _isOn = false;

  bool get isOn => _isOn;

  void turnOn(bool flash) {
    if (flash) {
      TorchCompat.turnOn();
    } else {
      TorchCompat.turnOff();
    }
    _isOn = flash;
    notifyListeners();
  }
}

class BitMode extends ChangeNotifier {
  Mode _mode = Mode.PWM;
  Mode get mode => _mode;
  int _c = 1;

  /// Switches Mode in a circular fashion.
  void changeMode() {
    _mode = Mode.values[(++_c) % Mode.values.length];
    notifyListeners();
  }
}
