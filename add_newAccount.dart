import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/apiservice.dart';
import 'package:flutter_application_1/service/helper.dart';
import 'package:flutter_application_1/widget/BackgroundCustNew.dart';
import 'package:flutter_application_1/widget/notificationWidget.dart';
import 'package:flutter_application_1/maps/maps.dart';
import 'package:flutter_application_1/page/level2/customerInfo.dart';
import 'package:flutter_application_1/page/level2/account_new_cust.dart';
import 'package:flutter_application_1/page/detailedit/detailedit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class addnewCust extends StatefulWidget {
  const addnewCust({super.key});

  @override
  State<addnewCust> createState() => _addnewCust();
}

class _addnewCust extends State<addnewCust> {
  final double topWidgetHeight = 112.0;
  final double avatarRadius = 50.0;
  late dynamic empcode = 10000;
  late dynamic NotificationCount = 0;
  helper helperController = Get.put(helper());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          background(
            topWidgetHeight: topWidgetHeight,
            avatarRadius: avatarRadius,
            empcode: empcode.toString(),
            version: helperController.version.value,
            count: NotificationCount,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ แถวบน: ไอคอน + หัวข้อ + ไอคอนขวา
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => newCust()),
                        );
                      },
                    ),
                    SizedBox(width: 12),
                    Text(
                      'ขอเปิดบัญชีลูกค้าใหม่',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(), // ✅ ดันให้ icon ด้านขวาอยู่สุด
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // ✅ ข้อความเตือน: แยกจาก Row อยู่ล่างลงมา
                Text(
                  'กรุณาเตรียมเอกสารให้ครบถ้วนก่อนอัปโหลด หากคุณปิดหน้านี้\n'
                  'เอกสารของคุณจะไม่ถูกบันทึก',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          // ✅ กล่องสีขาว 80% ล่าง ขอบมนเฉพาะด้านบน
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // 20% ด้านบน
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'การขอเปิดบัญชีลูกค้าใหม่',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'ขั้นตอนการขอเปิดบัญชี',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  SizedBox(height: 30),

                  // ✅ Step cards
                  buildStepCard(
                    1,
                    'ข้อมูลเบื้องต้นลูกค้า',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                customerInfoPage()), // 👈 หน้าที่ต้องการ
                      );
                    },
                  ),

                  buildStepCard(
                    2,
                    'อัพโหลดเอกสาร',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                customerInfoPage()), // 👈 หน้าที่ต้องการ
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildStepCard(int stepNumber, String title, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 🔵 วงกลมเลขลำดับ
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '$stepNumber',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(width: 12),
          // 📝 ข้อความ
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    ),
  );
}
