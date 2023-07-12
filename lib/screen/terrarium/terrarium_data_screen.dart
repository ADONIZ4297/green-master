import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_master/provider/terrariumDataProvider.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class TerrariumDataScreen extends HookConsumerWidget {
  const TerrariumDataScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("온도 습도 확인").textStyle(titleStyle).padding(all: 30),
            Spacer(),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("현재 온도").fontSize(20).fontWeight(FontWeight.bold).textColor(primaryColor),
                  Text(
                    (ref.watch(terrariumProvider).terrariumData.temperature.toDouble() / 100).toString() + "ºC",
                  ).fontSize(20).fontWeight(FontWeight.bold).textColor(primaryColor),
                ],
              ),
            ).center(),
            Spacer(),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: primaryColor,
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(100)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("현재 습도").fontSize(20).fontWeight(FontWeight.bold).textColor(primaryColor),
                  Text(
                    (ref.watch(terrariumProvider).terrariumData.humidity.toDouble() / 100).toString() + "%",
                  ).fontSize(20).fontWeight(FontWeight.bold).textColor(primaryColor),
                ],
              ),
            ).center(),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
