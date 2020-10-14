import 'package:bit_flasher/modulators/modulator.dart';
import 'package:binary/binary.dart';
import 'package:characters/characters.dart';

class NRZModulator extends Modulator {
  @override
  String decode(List<bool> bits) {
    final sb = StringBuffer();
    int c = 0;

    final tl = List<String>.generate(8, (index) => "0");

    for (final b in bits) {
      tl[c] = b ? "1" : "0";
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

  @override
  List<bool> encode(String message) {
    final data = <bool>[];
    for (var char in message.codeUnits) {
      // get last 8 bits.
      String bin = char.toBinaryPadded(8);
      bin = bin.substring(bin.length - 8);

      for (final c in bin.characters) {
        if (c == "0") {
          data.add(false);
        } else if (c == "1") {
          data.add(true);
        }
      }
    }

    return data;
  }
}
