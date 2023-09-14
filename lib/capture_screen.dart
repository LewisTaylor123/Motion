import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helping_mum_motion/capture_controller.dart';

const int maxX = 120;

class CaptureScreen extends GetView<CaptureController> {
  static String routeName = '/$CaptureScreen';

  const CaptureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/helping_mum_static.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Room Motion',
                  style: TextStyle(fontSize: 25),
                ),
              ),
              Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildChart(controller.rxLastMinute),
                    _buildChart(controller.rxLastHour),
                  ],
                );
              }),
              _buildCameraFeed()
            ],
          ),
        ),
      ),
    );
  }

  Container _buildChart(List<BarChartGroupData> data) {
    return Container(
      margin: const EdgeInsets.all(15.0),
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueAccent),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4,
            offset: Offset(4, 8), // Shadow position
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 300,
          width: 600,
          child: BarChart(
            BarChartData(
              barTouchData: barTouchData,
              titlesData: titlesData,
              borderData: borderData,
              barGroups: data,
              gridData: const FlGridData(show: false),
              alignment: BarChartAlignment.spaceAround,
              maxY: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraFeed() {
    return Obx(
        () => controller.rxPath1.value != '' && controller.rxPath2.value != ''
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox.square(
                      dimension: 160,
                      child: Image.file(File(controller.rxPath1.value))),
                  SizedBox.square(
                      dimension: 160,
                      child: Image.file(File(controller.rxPath2.value))),
                ],
              )
            : const SizedBox());
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => const FlTitlesData(
        show: true,
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );
}
