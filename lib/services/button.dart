import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Button extends HookWidget {
  Button(
      {Key? key, required this.child, this.margin, this.padding, this.pressSize, this.noColor, required this.onPressed})
      : super(key: key);
  Widget child;
  EdgeInsets? padding;
  EdgeInsets? margin;
  Function() onPressed;
  double? pressSize;
  bool? noColor;

  @override
  Widget build(BuildContext context) {
    var isCliked = useState(false);
    // var opacity = useState(1.0);
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
            scale: isCliked.value ? (pressSize ?? 0.9) : 1,
            curve: Curves.easeOutCubic,
            duration: const Duration(milliseconds: 150),
            child: Container(
              color: Colors.transparent,
              margin: margin,

              // child: ClipRect(
              //   child: child,
              // ),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      child: child,
                      margin: padding,
                    ),
                  ),
                  if (noColor != true)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isCliked.value ? Colors.black.withOpacity(0.1) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
