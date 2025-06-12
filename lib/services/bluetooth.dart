import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:flutter_blue_plus/gen/flutterblueplus.pbserver.dart';
// import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Bluetooth {
  // final flutterReactiveBle = FlutterReactiveBle();
  // var flutterBlue = FlutterBluePlus.isAvailable;
  List<BluetoothDevice> connectedDevices = [];
  List<ScanResult> scanResults = [];
  bool isScanning = false;

  Bluetooth() {
    init();

    // flutterReactiveBle.statusStream.listen((status) {
    //   print(status);
    //   status.
    //   //code for handling status update
    // });
    // print("start");
    // flutterReactiveBle.scanForDevices(withServices: [], scanMode: ScanMode.lowLatency).listen((device) {
    //   print(device);
    //   //code for handling results
    // }, onError: () {
    //   // code for handling error
    // });
    // Stream.periodic(const Duration(seconds: 2)).asyncMap((_) => flutterBlue.connectedDevices).listen((event) {
    //   print(event.length);
    //   devices = event;
    // });
  }

  void init() async {
    if (await FlutterBluePlus.isAvailable) {
      await checkConnected();
      await scan();
    }
  }

  // service(Device device) async {
  //   List<BluetoothService> services = await device.discoverServices();
  // }
  checkConnected() async {
    connectedDevices = await FlutterBluePlus.connectedDevices;
  }

  scan() async {
    if (!isScanning) {
      // 스캔 중이 아니라면
      // 기존에 스캔된 리스트 삭제
      scanResults.clear();
      // 스캔 시작, 제한 시간 4초
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 60));
      // 스캔 결과 리스너
      FlutterBluePlus.scanResults.listen((results) {
        print(results.length);
        // List<ScanResult> 형태의 results 값을 scanResultList에 복사
        scanResults = results;
      });
    } else {
      // 스캔 중이라면 스캔 정지
      FlutterBluePlus.stopScan();
    }
  }
}

final bluetoothProvider = Provider<Bluetooth>((ref) {
  return Bluetooth();
});
