import 'package:firebase_database/firebase_database.dart';
import 'package:green_master/provider/greenwallRefProvider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final greenWallSettingProvider = StreamProvider((ref) {
  return ref.watch(greenWallRefProvider).child("setting").onValue;
});
