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

  void send(
    String message,
    FlashState flasher,
    Mode mode,
    int millisec, {
    bool withDelimeters = true,
  }) async {
    final flashDuration = Duration(milliseconds: millisec);

    var payload = _makeRawPayload(mode, message);
    if (withDelimeters) {
      payload = _addDelimeters(payload);
    }
    shoudldStop = false;
    // TODO: add message header.
    for (final bit in payload) {
      if (bit) {
        flasher.turnOn();
      } else {
        flasher.turnOff();
      }
      await Future.delayed(flashDuration);
      if (shoudldStop) break;
    }
    // TODO: add message tail.
    flasher.turnOff();
  }

  /// A boolean message payload without any delimeters.
  List<bool> _makeRawPayload(Mode mode, String message) {
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

  /// Adds start and end delimeters and escapes delimeters inside.
  List<bool> _addDelimeters(List<bool> list) {
    String bitString = list
        .toBitString()
        .replaceAll(escapeByte, escapeByte + escapeByte)
        .replaceAll(flagByte, escapeByte + flagByte);

    return (flagByte + bitString + flagByte).toBoolList();
  }
}

extension on String {
  /// Convert string like 100110101 to list<bool>.
  List<bool> toBoolList() {
    List<bool> res;
    for (var i = 0; i < this.length; i++) {
      if (this[i] == '1') {
        res.add(true);
      } else if (this[i] == '0') {
        res.add(false);
      } else {
        throw Exception('Illegal bitstring');
      }
    }
    return res;
  }
}

extension on List<bool> {
  /// Convert list<bool> to bitstring like 11001101.
  String toBitString() {
    return this.map((e) => e ? '1' : '0').join('');
  }
}
