import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:green_master/provider/greenwallDataProvider.dart';
import 'package:green_master/provider/greenwallSettingProvider.dart';
import 'package:green_master/provider/greenwallRefProvider.dart';
import 'package:green_master/screen/green%20wall/greenwall_manage_screen.dart';
import 'package:green_master/services/button.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:green_master/services/greenButton.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class GreenWallFindScreen extends HookConsumerWidget {
  const GreenWallFindScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var controller = useTextEditingController(text: "test10");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "그린월 관리\n모델명 입력",
          ).textStyle(titleStyle),
          const SizedBox(height: 20),
          TextField(
            autofocus: true,
            controller: controller,
            cursorColor: primaryColor,
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 2,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: primaryColor,
                  width: 4,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Spacer(),
              GreenButton(
                width: 150,
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                text: "완료",
                onPressed: () async {
                  if (controller.text.isEmpty) {
                    return;
                  }
                  var data = await db.ref(controller.text).get();
                  if (!data.exists) {
                    Fluttertoast.showToast(
                      msg: "기기가 존재하지 않습니다",
                      gravity: ToastGravity.TOP,
                      backgroundColor: primaryColor,
                    );
                    return;
                  }
                  FocusScope.of(context).unfocus();
                  ref.read(greenWallRefProvider.notifier).state = db.ref(controller.text);
                  ref.refresh(greenWallDataProvider);
                  ref.refresh(greenWallSettingProvider);
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const GreenWallManage()),
                  );
                },
              ),
            ],
          )
        ],
      ).padding(all: 30),
    );
  }
}
