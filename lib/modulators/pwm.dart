import 'package:bit_flasher/modulators/modulator.dart';
import 'package:binary/binary.dart';
import 'package:characters/characters.dart';

class PWMModulator extends Modulator {
  @override
  String decode(List<bool> bits) {
    final sb = StringBuffer();
    int c = 0;

    final tl = List<String>.generate(8, (index) => "0");

    int i = 0;
    while (i < bits.length) {
      if (bits[i] && !bits[i + 1]) {
        // short pulse 10
        i += 2;
        tl[c] = "0";
      } else if (bits[i] && bits[i + 1] && bits[i + 2] && !bits[i + 3]) {
        // long pulse 1110
        i += 4;
        tl[c] = "1";
      } else {
        throw Exception("Unknown sequence");
      }

      c++;
      if (c == 8) {
        sb.write(String.fromCharCode(tl.join('').bits));
        c = 0;
      }
    }

    if (c != 0) {
      throw Exception("Missing bits.");
    }

    return sb.toString();
  }

  /// Each character is converted to binary and transmitted.
  /// A '0' is short pulse and 1 s longer pulse.
  @override
  List<bool> encode(String message) {
    final data = <bool>[];
    for (var char in message.codeUnits) {
      // get last 8 bits.
      String bin = char.toBinaryPadded(8);
      bin = bin.substring(bin.length - 8);

      for (final c in bin.characters) {
        if (c == "0") {
          data.add(true);
          data.add(false);
        } else if (c == "1") {
          data.add(true);
          data.add(true);
          data.add(true);
          data.add(false);
        }
      }
    }

    return data;
  }
}
