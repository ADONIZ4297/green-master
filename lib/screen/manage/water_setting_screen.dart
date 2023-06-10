import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_master/provider/greenwallSettingProvider.dart';
import 'package:green_master/provider/greenwallRefProvider.dart';
import 'package:green_master/services/button.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/extension.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:green_master/services/greenButton.dart';
import 'package:green_master/services/modalPopup.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:styled_widget/styled_widget.dart';

var dateFormat = DateFormat("H시간 m분");

class WaterSettingScreen extends HookConsumerWidget {
  const WaterSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var motor = ref.watch(greenWallSettingProvider).value!.snapshot.child("motor");
    var periodTime = useState<DateTime>(DateTime.now());
    var workingTime = useState<DateTime>(DateTime.now());
    var isAuto = useState(true);
    var isOn = useState(true);
    useMemoized(() {
      periodTime.value = DateTime.parse("2023-06-09 ${motor.child("periodTime").value.toString()}");
      workingTime.value = DateTime.parse("2023-06-09 ${motor.child("workingTime").value.toString()}");
      isAuto.value = motor.child("isAuto").value as bool;
      isOn.value = motor.child("isOn").value as bool;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("관수 시간 설정").textStyle(titleStyle),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: GreenButton(
                  unable: !isAuto.value,
                  text: "자동",
                  onPressed: () {
                    isAuto.value = true;
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GreenButton(
                  unable: isAuto.value,
                  text: "수동",
                  onPressed: () {
                    isAuto.value = false;
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: isAuto.value ? auto(context, periodTime, workingTime) : manual(isOn),
          ),
          GreenButton(
            width: 200,
            text: "설정",
            onPressed: () {
              Navigator.pop(context);
              String newPeriodTime = DateFormat.Hm().format(periodTime.value);
              String newWorkingTime = DateFormat.Hm().format(workingTime.value);
              ref.watch(greenWallRefProvider).child("setting").child("motor").update({
                "periodTime": newPeriodTime,
                "workingTime": newWorkingTime,
                "isAuto": isAuto.value,
                "isOn": isOn.value,
              });
            },
          ).center(),
          const SizedBox(height: 50),
        ],
      ).padding(all: 30),
    );
  }

  Column manual(ValueNotifier<bool> isOn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text("모터").textColor(darkGray).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 20),
        Row(
          children: [
            GreenButton(
              text: "ON",
              unable: !isOn.value,
              onPressed: () {
                isOn.value = true;
              },
            ).expanded(),
            const SizedBox(width: 10),
            GreenButton(
              text: "OFF",
              unable: isOn.value,
              onPressed: () {
                isOn.value = false;
              },
            ).expanded(),
          ],
        ),
      ],
    );
  }

  Column auto(BuildContext context, ValueNotifier<DateTime> startTime, ValueNotifier<DateTime> endTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text("모터 작동 주기").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 10),
        Button(
          pressSize: 0.94,
          onPressed: () async {
            var time = await showTimeModal(context, "모터 작동 주기 설정", startTime.value, true);
            if (time != null) {
              startTime.value = time;
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: gray),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(dateFormat.format(startTime.value))
                .fontWeight(FontWeight.bold)
                .fontSize(16)
                .textColor(darkGray)
                .center(),
          ),
        ),
        const SizedBox(height: 15),
        Text("모터 작동 시간").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 10),
        Button(
          pressSize: 0.94,
          onPressed: () async {
            var time = await showTimeModal(context, "모터 작동 시간 설정", endTime.value, true);
            if (time != null) {
              endTime.value = time;
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: gray),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Text(dateFormat.format(endTime.value))
                .fontWeight(FontWeight.bold)
                .fontSize(16)
                .textColor(darkGray)
                .center(),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
