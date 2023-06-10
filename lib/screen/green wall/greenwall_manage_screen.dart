import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:green_master/screen/manage/data_screen.dart';
import 'package:green_master/screen/manage/led_setting_screen.dart';
import 'package:green_master/screen/manage/water_setting_screen.dart';
import 'package:green_master/services/button.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:styled_widget/styled_widget.dart';

class GreenWallManage extends StatelessWidget {
  const GreenWallManage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "그린월 관리",
          ).textStyle(titleStyle),
          const SizedBox(height: 20),
          manageButton("식물등 LED 설정", "bulb", () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const LedSettingScreen()),
            );
          }),
          manageButton("관수 시간 설정", "click", () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const WaterSettingScreen()),
            );
          }),
          manageButton("온도 습도 확인", "temperature", () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => const DataScreen()),
            );
          }),
          const Spacer(),
          Button(
            noColor: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("모델명 변경하기").fontSize(16).fontWeight(FontWeight.bold),
          ).center(),
          Spacer(),
        ],
      ).padding(all: 30),
    );
  }

  Widget manageButton(String title, String image, Function onPressed) {
    return Button(
      noColor: true,
      onPressed: () {
        onPressed();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 4,
            offset: const Offset(2, 2),
          ),
        ]),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          width: double.infinity,
          height: 140,
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color: primaryColor,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                ).textColor(primaryColor).fontSize(20).fontWeight(FontWeight.w500),
              ),
              Image.asset("assets/images/${image}.png").padding(vertical: 15, horizontal: 10),
            ],
          ),
        ),
      ),
    );
  }
}
