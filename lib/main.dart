import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'capture_controller.dart';
import 'capture_screen.dart';
import 'graph_controller.dart';
import 'graph_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Helping Mum Motion',
      initialRoute: CaptureScreen.routeName,
      getPages: pages(),
    );
  }
}


List<GetPage> pages() {
  return [
    GetPage(
      name: GraphScreen.routeName,
      page: () => GraphScreen(),
      binding: GraphScreenBinding(),
    ),
    GetPage(
      name: CaptureScreen.routeName,
      page: () => const CaptureScreen(),
      binding: CaptureScreenBinding(),
    )
  ];
}

class GraphScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(GraphController());
  }
}
class CaptureScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CaptureController());
  }
}