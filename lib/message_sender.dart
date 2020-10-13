import 'package:bit_flasher/global.dart';

enum Mode { MOR, PWM, NRZ }

class MessageSender {
  void stop() {
    // TODO: stop all communication.
  }

  void send(String message, FlashState flasher, Mode mode) async {
    // TODO: use mode, message, flasher to flash message accordingly.
    for (final byte in message.codeUnits) {
      if (byte.isEven) {
        flasher.turnOn(false);
      } else {
        flasher.turnOn(true);
      }
      await Future.delayed(Duration(milliseconds: 20));
    }
  }
}
