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
                Expanded(flex: 25, child: Padding(
                  padding: const EdgeInsets.fromLTRB(20,12,20,8),
                  child: _buildCameraFeed(),
                ))
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
          Expanded(flex: 50, child: _buildChart(controller.rxLastMinute, 'Live')),
          Expanded(flex: 50, child: _buildChart(controller.rxLastHour, 'Past hour')),
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

  Padding _buildChart(List<BarChartGroupData> data,String chartTitle) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
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
            child: Column(
              children: [
                Expanded(
                  flex: 80,
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
                Expanded(flex: 0,child: Container(height: 1,color: Colors.black,)),
                Expanded(flex:0,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(chartTitle),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraFeed() {
    return Obx(
      () =>  Container(
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Center(child: Container(color: Colors.transparent,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Camera Feed'),
                )),),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                      _lastFivePhotos(),

                  ),
              ],
            ),
          ),
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

  List<Widget> _lastFivePhotos() {
    List<Widget> imageWidgets = <Widget>[];
     for (String path in controller.rxLastFivePhotoPaths) {
       imageWidgets.add(Container(child: Container(child: _photoFrame(Image.file(File(path))))));
        }
    while(imageWidgets.length < 5) {
      imageWidgets.insert(0,  _photoFrame(Image.asset('assets/helping_mum_static.png')));
     };
     return imageWidgets;
  }

  Widget _photoFrame(Widget child) {
    return Expanded(flex: 20 ,child: Container(

      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ClipRRect(
      borderRadius: BorderRadius.circular(20.0),child: child)),
    ),
    );
  }
}
