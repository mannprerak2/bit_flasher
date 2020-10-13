/// Base class for all modulators.
abstract class Modulator {
  List<bool> encode(String message);
  String decode(List<bool> bits);
}
