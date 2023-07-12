import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:green_master/model/terrariumData.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final characterProvider = StateProvider<BluetoothCharacteristic?>((ref) {
  return null;
});

// final terrariumCharacterProvider = StreamProvider<List<int>>((ref) {
//   return  ?? const Stream.empty();
// });

class TerrariumRepository extends ChangeNotifier {
  var terrariumData = TerrarariumData();
  // var terrariumData = StreamController<TerrarariumData>();
  TerrariumRepository(ChangeNotifierProviderRef ref) {
    ref.watch(characterProvider)?.onValueChangedStream.listen((event) {
      var string = utf8.decode(event);
      print(string);
      switch (string.substring(0, 2)) {
        case "HH":
          terrariumData.humidity = int.parse(string.substring(2));
          return notifyListeners();
        case "TT":
          terrariumData.temperature = int.parse(string.substring(2));
          return notifyListeners();
        case "LS":
          terrariumData.lampStart = string.substring(2);
          return notifyListeners();
        case "LE":
          terrariumData.lampEnd = string.substring(2);
          return notifyListeners();
        case "VP":
          terrariumData.vaporizerPeriod = string.substring(2);
          return notifyListeners();
        case "VT":
          terrariumData.vaporizerTime = string.substring(2);
          return notifyListeners();
        case "VO":
          terrariumData.vaporizerOn = string.substring(2) == "1";
          return notifyListeners();
        case "VA":
          terrariumData.vaporizerAuto = string.substring(2) == "1";
          return notifyListeners();
        case "LO":
          terrariumData.lampOn = string.substring(2) == "1";
          return notifyListeners();
        case "LA":
          terrariumData.lampAuto = string.substring(2) == "1";
          return notifyListeners();
        default:
      }
    });
  }
}

final terrariumProvider = ChangeNotifierProvider<TerrariumRepository>((ref) {
  return TerrariumRepository(ref);
});
// final terrariumDataProvider = Provider<String>((ref) {
//   return utf8.decode(ref.watch(terrariumDataProvider).value ?? []);
// });
