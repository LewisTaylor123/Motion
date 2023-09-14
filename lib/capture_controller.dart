import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_compare/image_compare.dart';

class CaptureController extends GetxController {
  Timer? timer;
  CameraController? cameraController;
  int index = 0;
  List<String> theList = [];
  RxString rxPath1 = ''.obs;
  RxString rxPath2 = ''.obs;
  RxString rxDiff = ''.obs;
  RxList<double> rxList = <double>[].obs;

  @override
  Future<void> onInit() async {
    //_mockTakePhotos();
    _inistialiseCameraAndStartTakingPhotos();
    super.onInit();
  }

  _inistialiseCameraAndStartTakingPhotos() async {
    final cameras = await availableCameras();

    CameraDescription? front = cameras.firstWhereOrNull(
        (element) => element.lensDirection == CameraLensDirection.back);

    if (front != null) {
      cameraController = CameraController(
        front,
        ResolutionPreset.low,
      );

      await cameraController?.initialize();
      takePhotos(rxList);
    }
  }

  List<Color> gradientColors = [
    Colors.grey,
    Colors.blue,
  ];

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Future<double> compare(String path1, String path2) async {
    double result = await compareImages(src1: File(path1), src2: File(path2));

    print(result);

    return result;
  }

  takePhotos(list) {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        //await _initializeControllerFuture;

        const int maxX = 120;

        final image = await cameraController?.takePicture();
        print(image);

        if (image == null) return;

        final String duplicateFilePath =
            (await getApplicationDocumentsDirectory()).path;


        String filePath = '$duplicateFilePath/${index.toString()}';
        await image.saveTo(filePath);
        index++;
        theList.add(filePath);
        if (theList.length > 1) {
          String path1 = theList[theList.length - 1];
          String path2 = theList[theList.length - 2];

          double diff = await compare(path1, path2);

          List lastThirty =
          barGroups.reversed.take(maxX).toList().reversed.toList();

          barGroups.add(BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: diff,
                gradient: _barsGradient,
              )
            ],
          ),);

          rxDiff.call(diff.toString());

          rxPath2.call(path2);
          rxPath1.call(path1);
        }
      } catch (e) {
        print(e);
      }
    });
  }

  _mockTakePhotos() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) async {
      rxList.add(Random().nextDouble());
    });
  }



  RxList<BarChartGroupData> barGroups = <BarChartGroupData> [

    /*BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 7,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 8,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 9,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 10,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 11,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 12,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 13,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 14,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 15,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 16,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 17,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 18,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 19,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 20,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 21,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 22,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 23,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 24,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 25,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 26,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 27,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 28,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),
    BarChartGroupData(
      x: 29,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          gradient: _barsGradient,
        )
      ],
    ),

     */
    BarChartGroupData(
      x: 30,
      barRods: [
        BarChartRodData(
          toY: 0.5,
          //gradient: _barsGradient,
        )
      ],
    ),


  ].obs;

  LinearGradient get _barsGradient => const LinearGradient(
    colors: [
      Colors.blue,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
}
