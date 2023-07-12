import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:green_master/provider/terrariumDataProvider.dart';
import 'package:green_master/screen/terrarium/terrarium_manager_screen.dart';
import 'package:green_master/services/bluetooth.dart';
import 'package:green_master/services/button.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';

class TerrariumFindScreen extends HookConsumerWidget {
  const TerrariumFindScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var animationController = useAnimationController(
      duration: const Duration(milliseconds: 1500),
    );
    var animate = useAnimation(CurvedAnimation(parent: animationController, curve: Curves.linear));
    useMemoized(() {
      animationController.repeat();
    });
    // ref.watch(bluetoothProvider);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("이끼 테라리움\n블루투스 기기 연동").textStyle(titleStyle),
          const SizedBox(height: 40),
          Stack(
            alignment: Alignment.center,
            children: [
              circle(animate, 3),
              circle(animate, 2),
              circle(animate, 1),
              circle(animate, 0),
              const Icon(
                Icons.bluetooth,
                color: Colors.white,
                size: 50,
              ),
            ],
          ).width(300).height(300).center(),
          const SizedBox(height: 20),
          // const Text("모델명").fontWeight(FontWeight.bold).fontSize(20),
          // const SizedBox(height: 10),
          ListView(
            children: [
              if (ref.watch(bluetoothProvider).connectedDevices.isNotEmpty)
                Text("연결됨").fontWeight(FontWeight.bold).fontSize(20),
              for (var device in ref.watch(bluetoothProvider).connectedDevices)
                deviceWidget(device, true, ref, context).padding(vertical: 10),
              Text("기타 기기").fontWeight(FontWeight.bold).fontSize(20),
              for (var result in ref.watch(bluetoothProvider).scanResults)
                deviceWidget(result.device, false, ref, context).padding(vertical: 10),
            ],
          ).expanded()
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //   ],
          // ).expanded()
        ],
      ).padding(all: 30),
    );
  }

  Row deviceWidget(BluetoothDevice device, bool isConnected, WidgetRef ref, BuildContext context) {
    return Row(
      children: [
        Text(device.name).fontSize(16).fontWeight(FontWeight.w500),
        const Spacer(),
        Button(
          noColor: true,
          onPressed: () async {
            if (!isConnected) {
              await device.connect();
            }
            var services = await device.discoverServices();
            for (var service in services) {
              for (BluetoothCharacteristic c in service.characteristics) {
                print(c.uuid);
                if (c.uuid.toString() == "fec26ec4-6d71-4442-9f81-55bc21d658d6") {
                  c.setNotifyValue(true);
                  ref.read(characterProvider.notifier).state = c;
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => const TerrariuManage()),
                  );
                }
              }
            }
          },
          child: const Text("연결").textColor(Colors.white).bold().padding(vertical: 5, horizontal: 20).decorated(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
        ),
      ],
    );
  }

  Widget circle(double animate, int index) {
    return Container(
      alignment: Alignment.center,
      width: index * 80 + animate * 80,
      height: index * 80 + animate * 80,
    ).decorated(shape: BoxShape.circle, color: primaryColor.withOpacity((1 - 0.25 * index) - 0.25 * animate));
  }
}
