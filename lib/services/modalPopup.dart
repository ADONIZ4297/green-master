import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:green_master/services/greenButton.dart';
import 'package:styled_widget/styled_widget.dart';

Future<DateTime?> showTimeModal(BuildContext context, String text, DateTime dateTime, bool use24) async {
  return await showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return TimeModal(text: text, dateTime: dateTime, use24: use24);
    },
  );
}

class TimeModal extends StatelessWidget {
  TimeModal({super.key, required this.text, required this.dateTime, required this.use24});
  String text;
  DateTime dateTime;
  bool use24;

  @override
  Widget build(BuildContext context) {
    // DateTime? time;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      height: 400,
      width: double.infinity,
      child: Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text).fontSize(22).fontWeight(FontWeight.w500),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: dateTime,
                use24hFormat: use24,
                minuteInterval: 5,
                onDateTimeChanged: (value) {
                  dateTime = value;
                },
              ),
            ),
            // Expanded(
            //   child: TimePickerSpinner(
            //     is24HourMode: false,
            //   ),
            // ),
            GreenButton(
              text: "완료",
              onPressed: () {
                Navigator.pop(context, dateTime);
              },
            )
          ],
        ).padding(all: 30),
      ),
    );
  }
}
