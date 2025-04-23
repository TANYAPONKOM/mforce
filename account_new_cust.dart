import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/apiservice.dart';
import 'package:flutter_application_1/service/helper.dart';
import 'package:flutter_application_1/widget/BackgroundCustNew.dart';
import 'package:flutter_application_1/widget/notificationWidget.dart';
import 'package:flutter_application_1/maps/maps.dart';
import 'package:flutter_application_1/page/home.dart';
import 'package:flutter_application_1/page/level2/add_newAccount.dart';
import 'package:flutter_application_1/page/detailedit/detailedit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class newCust extends StatefulWidget {
  const newCust({super.key});

  @override
  State<newCust> createState() => _newCust();
}

class _newCust extends State<newCust> {
  final double topWidgetHeight = 112.0;
  final double avatarRadius = 50.0;
  late dynamic empcode = 10000;
  late dynamic NotificationCount = 0;
  helper helperController = Get.put(helper());

  int selectedTabIndex = 0;

  final List<String> tabs = ['ทั้งหมด', 'รอดำเนินการ', 'รออนุมัติ', 'สำเร็จ'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          background(
            topWidgetHeight: topWidgetHeight,
            avatarRadius: avatarRadius,
            empcode: empcode.toString(),
            version: helperController.version.value,
            count: NotificationCount,
          ),
          Positioned(
            width: MediaQuery.of(context).size.width,
            top: 0,
            bottom: 30,
            child: Column(
              children: [
                // ✅ ส่วนหัวสีขาว
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 🔍 แถวค้นหา
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.black),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                  );
                                },
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    prefixIcon: Icon(Icons.search),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              // ✅ ปุ่มเพิ่มข้อมูล ไปหน้าอื่น
                              IconButton(
                                icon: Icon(Icons.add_box, color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            addnewCust()), // ← ใส่ชื่อหน้าของคุณ
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          // 🔵 แถบ Tab ที่กดได้
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(tabs.length, (index) {
                              final isSelected = selectedTabIndex == index;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTabIndex = index;
                                  });
                                },
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tabs[index],
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.grey,
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Container(
                                      height: 3,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ✅ ส่วน scroll รายการ
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: List.generate(4, (index) {
                              String imageName =
                                  'images/testt_${index + 1}.png';

                              return Container(
                                height: 135,
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // ✅ ให้จัดชิดบน
                                  children: [
                                    // ✅ รูปภาพ
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imageName,
                                        width: 100,
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(width: 16),

                                    // ✅ ข้อความชิดบน
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // บรรทัดบน: หัวเรื่อง
                                          Text(
                                            'ก่อสร้างอพาร์ทเม้น 5 ชั้น',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  221, 42, 39, 227),
                                            ),
                                          ),
                                          SizedBox(height: 5),

                                          // บรรทัดล่าง: วันที่สร้าง - ข้อมูลอยู่ฝั่งขวา
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'วันที่สร้าง',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                '28/03/2025', // ← ปรับเป็นค่าจริงตามต้องการ
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 116, 116, 116),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 3),

                                          // บรรทัดล่าง: วันที่สร้าง - ข้อมูลอยู่ฝั่งขวา
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'สถานนะ',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: const Color.fromARGB(
                                                      255, 116, 116, 116),
                                                ),
                                              ),
                                              Text(
                                                'รอดำเนินการ', // ← ปรับเป็นค่าจริงตามต้องการ
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 210, 64, 64),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width:
                                                    230, // 👈 กำหนดความกว้างแบบเดียวกับระยะ "สถานะ ↔ รอดำเนินการ"
                                                height: 32,
                                                child: ElevatedButton(
                                                  onPressed:
                                                      () {}, // ยังไม่ทำอะไร
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.grey[
                                                            300], // สีพื้นปุ่ม
                                                    foregroundColor: Colors
                                                        .black87, // สีตัวอักษร
                                                    elevation: 0,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'ดูรายละเอียด',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
