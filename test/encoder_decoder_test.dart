import 'package:bit_flasher/modulators/morse.dart';
import 'package:bit_flasher/modulators/nrz.dart';
import 'package:bit_flasher/modulators/pwm.dart';
import 'package:test/test.dart';

void main() {
  test('NRZ decode and encode test', () {
    String tst = r"abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()/\;:'[]{}";

    final modulator = NRZModulator();

    expect(tst, modulator.decode(modulator.encode(tst)));
  });
  test('PWM decode and encode test', () {
    String tst = r"abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()/\;:'[]{}";

    final modulator = PWMModulator();

    expect(tst, modulator.decode(modulator.encode(tst)));
  });
  test('MORSE decode and encode test', () {
    String tst = r"abcdefghijklmnopqrstuvwxyz0123456789";

    final modulator = MorseModulator();

    expect(tst, modulator.decode(modulator.encode(tst)));
  });
}
