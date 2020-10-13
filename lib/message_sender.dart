import 'package:bit_flasher/modulators/morse.dart';
import 'package:bit_flasher/modulators/pwm.dart';
import 'package:bit_flasher/global.dart';

import 'modulators/nrz.dart';

enum Mode { MOR, PWM, NRZ }

class MessageSender {
  final morseModulator = MorseModulator();
  final pwmModulator = PWMModulator();
  final nrzModulator = NRZModulator();
  bool shoudldStop = true;
  void stop() {
    shoudldStop = true;
  }

  void send(String message, FlashState flasher, Mode mode, int millisec) async {
    final flashDuration = Duration(milliseconds: millisec);

    final payload = _makePayload(mode, message);
    shoudldStop = false;
    // TODO: add message header.
    for (final bit in payload) {
      if (bit) {
        flasher.turnOn();
        flasher.turnOff();
      }
      await Future.delayed(flashDuration);
      if (shoudldStop) break;
    }
    // TODO: add message tail.
    flasher.turnOff();
  }

  List<bool> _makePayload(Mode mode, String message) {
    switch (mode) {
      case Mode.MOR:
        return morseModulator.encode(message);
      case Mode.PWM:
        return pwmModulator.encode(message);
      case Mode.NRZ:
        return nrzModulator.encode(message);
    }
    throw Exception("Unknown mode");
  }
}
