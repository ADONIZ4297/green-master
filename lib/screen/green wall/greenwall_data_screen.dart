import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:green_master/provider/greenwallDataProvider.dart';
import 'package:green_master/services/colors.dart';
import 'package:green_master/services/extension.dart';
import 'package:green_master/services/fontStyle.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GreenWallDataScreen extends ConsumerWidget {
  const GreenWallDataScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(greenWallDataProvider).when(
      data: (data) {
        Map tempData = data.snapshot.child("temperature").value as Map;

        if (tempData == {}) {
          return Text("데이터가 없습니다");
        }
        // Map<DateTime, double> temperatureMap = {};
        List<MapEntry<DateTime, double>> temperatureList = [];
        tempData.forEach((key, value) {
          var date = DateTime.parse(key);
          print(date);
          if (isSameDay(date, DateTime.now())) {
            temperatureList.add(MapEntry(date, value));
          }
        });
        temperatureList.sort(
          (a, b) {
            return a.key.compareTo(b.key);
          },
        );
        Map humiData = data.snapshot.child("humidity").value as Map;
        // Map<DateTime, double> temperatureMap = {};
        List<MapEntry<DateTime, double>> humiList = [];
        humiData.forEach((key, value) {
          var date = DateTime.parse(key);
          print(date);
          if (isSameDay(date, DateTime.now())) {
            humiList.add(MapEntry(date, value));
          }
        });
        humiList.sort(
          (a, b) {
            return a.key.compareTo(b.key);
          },
        );

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("온도 습도 확인").textStyle(titleStyle).padding(all: 30),
              Text("현재온도 " + temperatureList.last.value.toString() + "ºC")
                  .textColor(primaryColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.w500)
                  .padding(vertical: 7, horizontal: 12)
                  .decorated(
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(color: primaryColor, width: 1.5),
                  )
                  // .border(color: primaryColor, all: 2)
                  .padding(horizontal: 30),
              const SizedBox(height: 20),
              chart(temperatureList, 'point.yºC').padding(horizontal: 20).expanded(),
              Text("현재습도 " + humiList.last.value.toString() + "%")
                  .textColor(primaryColor)
                  .fontSize(16)
                  .fontWeight(FontWeight.w500)
                  .padding(vertical: 7, horizontal: 12)
                  .decorated(
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(color: primaryColor, width: 1.5),
                  )
                  // .border(color: primaryColor, all: 2)
                  .padding(horizontal: 30),
              chart(humiList, 'point.y%').padding(horizontal: 20).expanded(),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
      error: (error, stackTrace) {
        return const Text("데이터 없음");
      },
      loading: () {
        return const Text("데이터 로딩");
      },
    );
  }

  SfCartesianChart chart(List<MapEntry<DateTime, double>> temperatureList, String format) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        axisLine: AxisLine(
          width: 3,
          color: gray,
        ),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(color: gray, width: 1.3),
        desiredIntervals: 2,
        axisLine: const AxisLine(
          width: 0,
        ),
      ),
      zoomPanBehavior: ZoomPanBehavior(
        enablePinching: true,
        zoomMode: ZoomMode.x,
        enablePanning: true,
      ),
      tooltipBehavior: TooltipBehavior(
          enable: true,
          format: format,
          // format: 'point.y ℃',
          header: "",
          color: Colors.white,
          canShowMarker: false,
          textStyle: TextStyle(
            color: primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          )
          // color: Colors.white,
          ),
      series: <ChartSeries>[
        SplineSeries<MapEntry<DateTime, double>, DateTime>(
          dataSource: temperatureList,
          splineType: SplineType.natural,
          color: primaryColor,
          width: 3,
          // xValueMapper: (MapEntry<DateTime, double> data, _) => data.key.hour * 60 + data.key.minute,
          xValueMapper: (MapEntry<DateTime, double> data, _) => data.key,
          yValueMapper: (MapEntry<DateTime, double> data, _) => data.value,
        )
      ],
    );
  }
}
