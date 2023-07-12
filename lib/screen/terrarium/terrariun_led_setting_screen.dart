import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:green_master/provider/greenwallSettingProvider.dart';
import 'package:green_master/provider/greenwallRefProvider.dart';
import 'package:green_master/provider/terrariumDataProvider.dart';
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

class TerrariumLedSettingScreen extends HookConsumerWidget {
  const TerrariumLedSettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var startTime = useState<DateTime>(DateTime.now());
    var endTime = useState<DateTime>(DateTime.now());
    var isAuto = useState(true);
    var isOn = useState(true);
    useMemoized(() {
      var data = ref.read(terrariumProvider).terrariumData;
      startTime.value = DateTime.parse("2023-06-09 ${data.lampStart}");
      endTime.value = DateTime.parse("2023-06-09 ${data.lampEnd}");
      isAuto.value = data.lampAuto;
      isOn.value = data.lampOn;
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
            child: isAuto.value ? auto(context, startTime, endTime) : manual(isOn),
          ),
          GreenButton(
            width: 200,
            text: "설정",
            onPressed: () async {
              // String newEndTime = DateFormat.Hm().format(endTime.value);
              // String newStartTime = DateFormat.Hm().format(startTime.value);
              var cha = ref.read(characterProvider);
              // var string = "F1000";
              var newStartTime = "LS" + DateFormat("HHmm").format(startTime.value);
              await cha?.write(newStartTime.codeUnits, withoutResponse: true);
              var newEndTime = "LE" + DateFormat("HHmm").format(endTime.value);
              await cha?.write(newEndTime.codeUnits, withoutResponse: true);
              var newisAuto = "LA" + (isAuto.value ? '1' : '0');
              await cha?.write(newisAuto.codeUnits, withoutResponse: true);
              var newisOn = "LO" + (isOn.value ? '1' : '0');
              await cha?.write(newisOn.codeUnits, withoutResponse: true);
              // var string2 = "F2000";
              // cha?.write([6, 7, 8, 9, 10, 11, 12], withoutResponse: true);
              // cha?.write([13, 14], withoutResponse: true);
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

  Column manual(ValueNotifier<bool> isOn) {
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
      ],
    );
  }

  Column auto(BuildContext context, ValueNotifier<DateTime> startTime, ValueNotifier<DateTime> endTime) {
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
      ],
    );
  }
}
