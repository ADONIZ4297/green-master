import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:green_master/screen/homeScreen.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "NotoSans",
          useMaterial3: true,
          scaffoldBackgroundColor: background,
          appBarTheme: AppBarTheme(
            backgroundColor: background,
            iconTheme: IconThemeData(color: primaryColor),
          ),
        ),
        home: const HomeScreen(),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
          ),
          child: child!,
        ),
      ),
    );
  }
}
