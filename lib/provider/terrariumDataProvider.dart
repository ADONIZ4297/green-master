import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final characterProvider = StateProvider<BluetoothCharacteristic?>((ref) {
  return null;
});

final terrariumDataProvider = StreamProvider<List<int>>((ref) {
  return ref.watch(characterProvider)?.value ?? const Stream.empty();
});
