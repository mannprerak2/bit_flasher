import 'package:camera/camera.dart';

class Global {
  List<CameraDescription> cameras;

  // Singleton class.
  static final Global _global = Global._();
  factory Global() {
    return _global;
  }
  Global._();
}
