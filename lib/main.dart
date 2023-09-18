import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:helping_mum_motion/capture_controller.dart';
import 'package:helping_mum_motion/capture_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  // Step 3
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((value) => runApp(const MyApp()));

  runApp(const MyApp());
}

/// entry widget for the app
class MyApp extends StatelessWidget {
  // empty constructor
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

/// the pages of the app
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

/// binding for the capture screen
class CaptureScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CaptureController());
  }
}
