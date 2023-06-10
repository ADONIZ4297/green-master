import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_master/services/colors.dart';
import 'package:styled_widget/styled_widget.dart';

class GreenButton extends HookWidget {
  GreenButton({Key? key, required this.text, this.margin, required this.onPressed, this.unable, this.width})
      : super(key: key);
  String text;
  EdgeInsets? margin;
  Function() onPressed;
  bool? unable;
  double? width;

  @override
  Widget build(BuildContext context) {
    var isCliked = useState(false);
    return Listener(
      onPointerDown: (event) {
        isCliked.value = true;
        // opacity.value = 0;
      },
      onPointerCancel: (event) {
        isCliked.value = false;
      },
      onPointerUp: (event) {
        try {
          isCliked.value = false;
        } catch (e) {}
      },

      // child: Text(isCliked.value.toString()),
      // onPressed: onPressed(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (event) {
          isCliked.value = true;
        },
        onExit: (event) => isCliked.value = false,
        child: GestureDetector(
          onTap: () {
            onPressed();
          },
          child: AnimatedScale(
            scale: isCliked.value ? 0.9 : 1,
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 150),
            child: Container(
              width: width,
              margin: margin,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
              decoration: BoxDecoration(
                color: unable == true ? background : primaryColor,
                border: Border.all(
                  color: primaryColor,
                ),
                borderRadius: BorderRadius.circular(200),
              ),
              child: Text(text)
                  .fontSize(16)
                  .textColor(unable == true ? primaryColor : Colors.white)
                  .fontWeight(FontWeight.bold)
                  .center(),
            ),
          ),
        ),
      ),
    );
  }
}
