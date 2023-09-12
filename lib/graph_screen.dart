import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:helping_mum_motion/graph_controller.dart';


class GraphScreen extends GetView<GraphController> {
  static String routeName = '/$GraphScreen';
  const GraphScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40,),
          Stack(
            children: <Widget>[

              const SizedBox(
                width: 60,
                height: 34,
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );


  }





}
