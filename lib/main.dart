import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'capture_controller.dart';
import 'capture_screen.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Helping Mum Motion',
      initialRoute: CaptureScreen.routeName,
      getPages: pages(),
    );
  }
}

// ignore: strict_raw_type
List<GetPage> pages() {
  return [
    GetPage(
      name: CaptureScreen.routeName,
      page: () => const CaptureScreen(),
      binding: CaptureScreenBinding(),
    )
  ];
}

class CaptureScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CaptureController());
  }
}
