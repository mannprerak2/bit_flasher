import 'package:bit_flasher/modulators/modulator.dart';
import 'package:flutter/material.dart';

class MorseModulator extends Modulator {
  @override
  String decode(List<bool> bits) {
    // TODO: implement decode
    throw UnimplementedError();
  }

  /// "a" is [1,3] and is converted to 101110
  @override
  List<bool> encode(String message) {
    final list = <bool>[];
    for (final char in message.characters) {
      if (_charList.containsKey(char)) {
        for (final i in _charList[char]) {
          for (int x = 0; x < i; x++) {
            list.add(true);
          }
          // gap between 2 dots in same character.
          list.add(false);
        }
        // gap between 2 characters
        list.add(false);
        list.add(false);
        list.add(false);
      }
    }
    return list;
  }

  Map<String, List<int>> _charList = {
    "a": [1, 3],
    "b": [3, 1, 1, 1],
    "c": [3, 1, 3, 1],
    "d": [3, 1, 1],
    "e": [1],
    "f": [1, 1, 3, 1],
    "g": [3, 3, 1],
    "h": [1, 1, 1, 1],
    "i": [1, 1],
    "j": [1, 3, 3, 3],
    "k": [3, 1, 3],
    "l": [1, 3, 1, 1],
    "m": [3, 3],
    "n": [3, 1],
    "o": [3, 3, 3],
    "p": [1, 3, 3, 1],
    "q": [3, 3, 1, 3],
    "r": [1, 3, 1],
    "s": [1, 1, 1],
    "t": [3],
    "u": [1, 1, 3],
    "v": [1, 1, 1, 3],
    "w": [1, 3, 3],
    "x": [3, 1, 1, 3],
    "y": [3, 1, 3, 3],
    "z": [3, 3, 1, 1],
    ".,": [1, 3, 1, 3, 1, 3],
    " ": [7],
    "0": [3, 3, 3, 3, 3],
    "1": [1, 3, 3, 3, 3],
    "2": [1, 1, 3, 3, 3],
    "3": [1, 1, 1, 3, 3],
    "4": [1, 1, 1, 1, 3],
    "5": [1, 1, 1, 1, 1],
    "6": [3, 1, 1, 1, 1],
    "7": [3, 3, 1, 1, 1],
    "8": [3, 3, 3, 1, 1],
    "9": [3, 3, 3, 3, 1]
  };
}
