import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:helping_mum_motion/capture_controller.dart';

/// the main screen in the app
class CaptureScreen extends GetView<CaptureController> {
  /// empty constructor
  const CaptureScreen({super.key});

  /// route name
  static String routeName = '/$CaptureScreen';

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(flex: 0, child: _title()),
                Expanded(flex: 50, child: _charts()),
                Expanded(flex: 50, child: _buildCameraFeed())
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _charts() {
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 48, child: _buildChart(controller.rxLastMinute)),
          const Expanded(
            flex: 4,
            child: SizedBox(),
          ),
          Expanded(flex: 48, child: _buildChart(controller.rxLastHour)),
        ],
      );
    });
  }

  Widget _title() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Room Motion',
        style: TextStyle(fontSize: 32),
      ),
    );
  }

  Container _buildChart(List<BarChartGroupData> data) {
    return Container(
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
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          child: BarChart(
            BarChartData(
              barTouchData: _barTouchData,
              titlesData: _titlesData,
              borderData: _borderData,
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
      () => controller.rxLastFivePhotoPaths.isNotEmpty
      
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (String path in controller.rxLastFivePhotoPaths)
                  Center(child: Text(path))
                  //Image.file(File(path)),
              ],
            )
          : Center(child: const Text('hello')),
    );
  }

  BarTouchData get _barTouchData => BarTouchData(
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

  FlTitlesData get _titlesData => const FlTitlesData(
        show: false,
      );

  FlBorderData get _borderData => FlBorderData(
        show: false,
      );
}
