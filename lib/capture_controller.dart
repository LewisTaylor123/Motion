import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compare/image_compare.dart';
import 'package:path_provider/path_provider.dart';

/// The main view of the app
class CaptureController extends GetxController {
  // public

  /// used to show the last images taken
  RxString rxPath1 = ''.obs;

  /// used to show the last images taken
  RxString rxPath2 = ''.obs;

  /// the data for the last minute
  RxList<BarChartGroupData> rxLastMinute = <BarChartGroupData>[].obs;

  /// the data for the last hour
  RxList<BarChartGroupData> rxLastHour = <BarChartGroupData>[].obs;

  // private

  Timer? _timer;
  CameraController? _cameraController;
  int _indexOfImageTaken = 0;
  final List<String> _listOfPathsToImages = [];

  final List<double> _dataList = <double>[].obs;

  @override
  Future<void> onInit() async {
    _mockTakePhotos();
    //await _inistialiseCameraAndStartTakingPhotos();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<double> _compare(String path1, String path2) async {
    final result = await compareImages(src1: File(path1), src2: File(path2));

    print(result);

    return result;
  }

  void _mockTakePhotos() {
    for (int i = 0; i < 1800; i++) {
      _addToBarGraphs(Random().nextDouble());
    }

    _timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) async {
      final newValue = Random().nextDouble();
      _addToBarGraphs(newValue);
    });
  }

  void _addToBarGraphs(double value) {
    _dataList.add(value);

    final lastMinute = _dataList.reversed.take(30).toList().reversed.toList();
    final lastHour = _dataList.reversed.take(150).toList().reversed.toList();

    rxLastMinute.clear();
    for (double val in lastMinute) {
      rxLastMinute.add(
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: val,
              gradient: _barsGradient,
            )
          ],
        ),
      );
    }

    rxLastHour.clear();
    for (double val in lastHour) {
      rxLastHour.add(
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: val,
              gradient: _barsGradient,
            )
          ],
        ),
      );
    }
  }

  //----------------------------------------

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  Future<void> _inistialiseCameraAndStartTakingPhotos() async {
    final cameras = await availableCameras();

    final front = cameras.firstWhereOrNull(
      (element) => element.lensDirection == CameraLensDirection.back,
    );

    if (front != null) {
      _cameraController = CameraController(
        front,
        ResolutionPreset.low,
      );

      await _cameraController?.initialize();
      takePhotos(_dataList);
    }
  }

  void takePhotos(list) {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final image = await _cameraController?.takePicture();
        if (image == null) return;

        // save the image to the file system
        final docsDirectoryPath =
            (await getApplicationDocumentsDirectory()).path;
        final filePath = '$docsDirectoryPath/$_indexOfImageTaken';
        await image.saveTo(filePath);

        _indexOfImageTaken++;
        _listOfPathsToImages.add(filePath);
        if (_listOfPathsToImages.length > 1) {
          final path1 = _listOfPathsToImages[_listOfPathsToImages.length - 1];
          final path2 = _listOfPathsToImages[_listOfPathsToImages.length - 2];

          final diff = await _compare(path1, path2);

          rxLastHour.add(
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: diff,
                  gradient: _barsGradient,
                )
              ],
            ),
          );

          rxPath2.call(path2);
          rxPath1.call(path1);
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
