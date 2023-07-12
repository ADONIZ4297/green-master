import 'package:flutter/material.dart';

// String asciiToHex(String asciiStr) {
//   List<int> chars = asciiStr.codeUnits;
//   StringBuffer hex = StringBuffer();
//   for (int ch in chars) {
//     hex.write(ch.toRadixString(16).padLeft(2, '0'));
//   }
//   return hex.toString();
// }

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

bool isSameDay(DateTime? dateA, DateTime? dateB) {
  return dateA?.year == dateB?.year && dateA?.month == dateB?.month && dateA?.day == dateB?.day;
}
