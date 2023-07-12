void main() {
  String asciiToHex(String asciiStr) {
    List<int> chars = asciiStr.codeUnits;
    StringBuffer hex = StringBuffer();
    for (int ch in chars) {
      hex.write(ch.toRadixString(16).padLeft(2, '0'));
    }
    return hex.toString();
  }

  print(asciiToHex("asndnakwdljfklasjdasjc"));
}
