import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:green_master/screen/green%20wall/greenwall_find_screen.dart';
import 'package:green_master/services/button.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Button(
            noColor: true,
            pressSize: 0.96,
            onPressed: () {},
            child: Image.asset(
              "assets/images/terrarium.png",
            ),
          ).center().expanded(),
          Button(
            noColor: true,
            pressSize: 0.96,
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const GreenWallFindScreen()),
              );
            },
            child: Image.asset(
              "assets/images/green wall.png",
            ),
          ).center().expanded(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
