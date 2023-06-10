import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

FirebaseDatabase db = FirebaseDatabase.instance;

final greenWallRefProvider = StateProvider<DatabaseReference>((ref) {
  return db.ref("test20").child("setting");
});
