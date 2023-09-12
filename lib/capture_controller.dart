import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:camera/camera.dart';
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
  RxList rxList = [].obs;

  @override
  Future<void> onInit() async {
    final cameras = await availableCameras();

    CameraDescription? front = cameras.firstWhereOrNull(
        (element) => element.lensDirection == CameraLensDirection.front);

    if (front != null) {
      cameraController = CameraController(
        front,
        ResolutionPreset.low,
      );

      await cameraController?.initialize();
      takePhotos(rxList);
    }
    super.onInit();
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


        final image = await cameraController?.takePicture();
        print(image);

        // Step 2: Check for valid file
        if (image == null) return;

// Step 3: Get directory where we can duplicate selected file.
        final String duplicateFilePath =
            (await getApplicationDocumentsDirectory()).path;

// Step 4: Copy the file to a application document directory.

        String filePath = '$duplicateFilePath/${index.toString()}';
        await image.saveTo(filePath);
        index++;
        theList.add(filePath);
        if (theList.length > 1) {
          String path1 = theList[theList.length - 1];
          String path2 = theList[theList.length - 2];

          double diff = await compare(path1, path2);

          rxList.add(diff);

          rxDiff.call(diff.toString());

          rxPath2.call(path2);
          rxPath1.call(path1);
        }
      } catch (e) {
        print(e);
      }
    });
  }
}
