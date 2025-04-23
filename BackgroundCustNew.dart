import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/employeeController.dart';
import 'package:flutter_application_1/notificationpage.dart';
import 'package:flutter_application_1/service/helper.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class background extends StatelessWidget {
  final double topWidgetHeight;
  final double avatarRadius;
  String empcode;
  final String version;
  final dynamic count;

  background(
      {required this.topWidgetHeight,
      required this.avatarRadius,
      required this.empcode,
      required this.version,
      required this.count});

  @override
  Widget build(BuildContext context) {
    helper helperController = Get.put(helper());
    EmployeeController emp = Get.put(EmployeeController());

    if (helperController.messageError.isNotEmpty) {
      print(helperController.messageError);
      switch (emp.employeeModel.value.data?.position_id) {
        case 'P00055':
          empcode = '77777';
          break;
        case 'P00001':
          empcode = '99999';
        case 'P00054':
          empcode = '88888';
          break;
        default:
      }
    }
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 83, 178, 246),
                Color(0xFFFFE6C1),
                Color(0xFF2396FF),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
