import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/FollowpageController.dart';
import 'package:flutter_application_1/service/apiservice.dart';
import 'package:flutter_application_1/service/helper.dart';
import 'package:flutter_application_1/widget/BackgroundCustNew.dart';
import 'package:flutter_application_1/widget/notificationWidget.dart';
import 'package:flutter_application_1/maps/maps.dart';
import 'package:flutter_application_1/page/level2/add_newAccount.dart';
import 'package:flutter_application_1/page/detailedit/detailedit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class customerInfoPage extends StatefulWidget {
  const customerInfoPage({super.key});

  @override
  State<customerInfoPage> createState() => _customerInfoPage();
}

class _customerInfoPage extends State<customerInfoPage> {
  final double topWidgetHeight = 112.0;
  final double avatarRadius = 50.0;
  late dynamic empcode = 10000;
  late dynamic NotificationCount = 0;
  helper helperController = Get.put(helper());
  final FollowpageController followPageController =
      Get.put(FollowpageController());
  String selectedType = 'นิติบุคคล';
  String? selectedAddress;

  // ✅ เพิ่ม mockLocations ไว้ในคลาส
  final List<Map<String, String>> mockLocations = [
    {'name': 'Bank 1656 Union Street', 'distance': '50 m'},
    {'name': 'Bank Secaucus', 'distance': '1.2 km'},
    {'name': 'Bank 1657 Riverside Drive', 'distance': '5.3 km'},
    {'name': 'Bank Rutherford', 'distance': '70 m'},
    {'name': 'Bank 1656 Union Street', 'distance': '30 m'},
  ];

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ค้นหาสถานที่',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.close),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: mockLocations.length,
                  itemBuilder: (context, index) {
                    final loc = mockLocations[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.location_on, color: Colors.purple),
                        title: Text(loc['name']!),
                        trailing: Text(
                          loc['distance']!,
                          style: TextStyle(color: Colors.grey),
                        ),
                        onTap: () {
                          setState(() {
                            selectedAddress = loc['name'];
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

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
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text('ข้อมูลลูกค้า',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.check_circle_outline, size: 30),
                  ],
                ),
                SizedBox(height: 10),
                Text('เพิ่มข้อมูลลูกค้าใหม่เพื่อขอเปิดบัญชีลูกค้า'),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('เลือกประเภทลูกค้า',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTypeButton('นิติบุคคล'),
                        SizedBox(width: 8),
                        _buildTypeButton('บุคคลทั่วไป'),
                      ],
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ค้นหาเลขทะเบียนนิติบุคคล'),
                    ),
                    SizedBox(height: 6),
                    TextField(
                        onChanged: (value) {
                          followPageController.getTaxId(value);
                          Logger().d(followPageController
                              .juristicPersonModel.value.data!.address);
                        },
                        decoration: _inputDecoration('Search')),
                    SizedBox(height: 20),
                    DashedContainer(
                      child: Column(
                        children: [
                          _buildSectionHeader('รายละเอียด'),
                          buildLabeledTextField('ชื่อลูกค้า', 'ชื่อลูกค้า'),
                          buildLabeledTextField(
                              selectedType == 'นิติบุคคล'
                                  ? 'เลขทะเบียนนิติบุคคล'
                                  : 'เลขบัตรประชาชน',
                              selectedType == 'นิติบุคคล'
                                  ? 'เลขทะเบียนนิติบุคคล'
                                  : 'เลขบัตรประชาชน'),
                          buildLabeledTextField('โทรศัพท์', 'โทรศัพท์'),
                          buildLabeledTextField(
                              'Email address', 'Email address'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('ค้นหาที่อยู่'),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: _openBottomSheet,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedAddress ?? 'ค้นหาสถานที่...',
                                style: TextStyle(
                                    color: selectedAddress == null
                                        ? Colors.grey
                                        : Colors.black),
                              ),
                            ),
                            if (selectedAddress != null)
                              Icon(Icons.check, color: Colors.green),
                          ],
                        ),
                      ),
                    ),
                    if (selectedAddress != null) ...[
                      SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 8), // 👈 ขยับจากขอบซ้าย 8px (ปรับตามชอบ)
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionHeader('ข้อมูลที่อยู่'),
                              SizedBox(height: 12),
                              Text(
                                'ที่อยู่ในการออกใบกำกับภาษี',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF2F3A5C),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                selectedAddress!,
                                style:
                                    TextStyle(fontSize: 13, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTypeButton(String label) {
    final isSelected = selectedType == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedType = label),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6A5AE0) : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  Widget _buildSectionHeader(String title) => Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );
}

Widget buildLabeledTextField(String label, String hint) => Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
          SizedBox(height: 6),
          TextField(
              decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ))
        ],
      ),
    );

class DashedContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;

  const DashedContainer({
    required this.child,
    this.radius = 16,
    this.color = const Color(0xFFB388EB),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashBorderPainter(radius: radius, color: color),
      child: Container(
        margin: EdgeInsets.all(1.5),
        padding: EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class DashBorderPainter extends CustomPainter {
  final double radius;
  final Color color;

  DashBorderPainter({required this.radius, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dashWidth = 6;
    const dashSpace = 4;

    final double maxX = size.width;
    final double maxY = size.height;

    void drawDashedLine(Offset start, Offset end) {
      final totalLength = (end - start).distance;
      final direction = (end - start) / totalLength;
      double current = 0;
      while (current < totalLength) {
        final from = start + direction * current;
        final to =
            start + direction * (current + dashWidth).clamp(0, totalLength);
        canvas.drawLine(from, to, paint);
        current += dashWidth + dashSpace;
      }
    }

    void drawDashedArc(Rect rect, double startAngle, double sweepAngle) {
      final path = Path()..addArc(rect, startAngle, sweepAngle);
      final metrics = path.computeMetrics().first;
      double distance = 0.0;
      while (distance < metrics.length) {
        final length = dashWidth.clamp(0, metrics.length - distance);
        final segment = metrics.extractPath(distance, distance + length);
        canvas.drawPath(segment, paint);
        distance += dashWidth + dashSpace;
      }
    }

    drawDashedLine(Offset(radius, 0), Offset(maxX - radius, 0));
    drawDashedLine(Offset(maxX, radius), Offset(maxX, maxY - radius));
    drawDashedLine(Offset(maxX - radius, maxY), Offset(radius, maxY));
    drawDashedLine(Offset(0, maxY - radius), Offset(0, radius));

    drawDashedArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        pi,
        pi / 2);
    drawDashedArc(
        Rect.fromCircle(center: Offset(maxX - radius, radius), radius: radius),
        -pi / 2,
        pi / 2);
    drawDashedArc(
        Rect.fromCircle(
            center: Offset(maxX - radius, maxY - radius), radius: radius),
        0,
        pi / 2);
    drawDashedArc(
        Rect.fromCircle(center: Offset(radius, maxY - radius), radius: radius),
        pi / 2,
        pi / 2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
