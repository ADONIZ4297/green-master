import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

var dateForamt = DateFormat("hh : mm");

class GreenWallLedSettingScreen extends HookConsumerWidget {
  const GreenWallLedSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var brighteness = useState<double>(0);
    var led = ref.watch(greenWallSettingProvider).value!.snapshot.child("led");
    var startTime = useState<DateTime>(DateTime.now());
    var endTime = useState<DateTime>(DateTime.now());
    var isAuto = useState(true);
    var isOn = useState(true);
    useMemoized(() {
      startTime.value = DateTime.parse("2023-06-09 ${led.child("startTime").value.toString()}");
      endTime.value = DateTime.parse("2023-06-09 ${led.child("endTime").value.toString()}");
      // startTime.value = DateTime.parse("2023-06-09 00:02");
      brighteness.value = (led.child("brightness").value as int).toDouble();
      isAuto.value = led.child("isAuto").value as bool;
      isOn.value = led.child("isOn").value as bool;
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("식물등 LED 설정").textStyle(titleStyle),
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
            child: isAuto.value ? auto(context, startTime, endTime, brighteness) : manual(isOn, brighteness),
          ),
          GreenButton(
            width: 200,
            text: "설정",
            onPressed: () async {
              String newEndTime = DateFormat.Hm().format(endTime.value);
              String newStartTime = DateFormat.Hm().format(startTime.value);
              await ref.watch(greenWallRefProvider).child("setting").child("led").update({
                "brightness": brighteness.value.toInt(),
                "endTime": newEndTime,
                "startTime": newStartTime,
                "isAuto": isAuto.value,
                "isOn": isOn.value,
              });
              Fluttertoast.showToast(
                msg: "설정 완료",
                gravity: ToastGravity.TOP,
                backgroundColor: primaryColor,
                textColor: Colors.white,
              );
            },
          ).center(),
          const SizedBox(height: 50),
        ],
      ).padding(all: 30),
    );
  }

  Column manual(ValueNotifier<bool> isOn, ValueNotifier<double> brighteness) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text("LED").textColor(darkGray).fontWeight(FontWeight.bold).fontSize(17),
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
        const SizedBox(height: 30),
        Text("밝기 조절").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 30),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            activeColor: primaryColor,
            // inactiveColor: primaryColor,
            thumbColor: primaryColor,
            value: brighteness.value,
            min: 0,
            max: 100,
            divisions: 100,
            label: brighteness.value.round().toString(),
            onChanged: (double newValue) {
              brighteness.value = newValue;
            },
          ),
        ),
        Row(
          children: [
            Text("0").textColor(gray),
            Spacer(),
            Text("100").textColor(gray),
          ],
        ),
      ],
    );
  }

  Column auto(BuildContext context, ValueNotifier<DateTime> startTime, ValueNotifier<DateTime> endTime,
      ValueNotifier<double> brighteness) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text("시작시간").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 10),
        Button(
          pressSize: 0.94,
          onPressed: () async {
            var time = await showTimeModal(context, "시작시간 설정", startTime.value, false);
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
            child: Row(
              children: [
                Text(dateForamt.format(startTime.value)).fontWeight(FontWeight.bold).fontSize(16).textColor(darkGray),
                Spacer(),
                Text(DateFormat("aa").format(startTime.value))
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)
                    .textColor(darkGray),
              ],
            ),
          ),
        ),
        const SizedBox(height: 15),
        Text("종료시간").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 10),
        Button(
          pressSize: 0.94,
          onPressed: () async {
            var time = await showTimeModal(context, "종료시간 설정", endTime.value, false);
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
            child: Row(
              children: [
                Text(dateForamt.format(endTime.value)).fontWeight(FontWeight.bold).fontSize(16).textColor(darkGray),
                const Spacer(),
                Text(DateFormat("aa").format(endTime.value))
                    .fontWeight(FontWeight.bold)
                    .fontSize(16)
                    .textColor(darkGray),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text("밝기 조절").textColor(Colors.black).fontWeight(FontWeight.bold).fontSize(17),
        const SizedBox(height: 30),
        SliderTheme(
          data: SliderThemeData(
            overlayShape: SliderComponentShape.noOverlay,
          ),
          child: Slider(
            activeColor: primaryColor,
            // inactiveColor: primaryColor,
            thumbColor: primaryColor,
            value: brighteness.value,
            min: 0,
            max: 100,
            divisions: 100,
            label: brighteness.value.round().toString(),
            onChanged: (double newValue) {
              brighteness.value = newValue;
            },
          ),
        ),
        Row(
          children: [
            Text("0").textColor(gray),
            Spacer(),
            Text("100").textColor(gray),
          ],
        ),
      ],
    );
  }
}
