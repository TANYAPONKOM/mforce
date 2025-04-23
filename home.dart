import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/page/level2/new_firsttime.dart';
import 'package:flutter_application_1/page/level2/new_secondtime.dart';
import 'package:flutter_application_1/page/level2/newthirdtime.dart';
import 'package:flutter_application_1/page/level2/secondtime.dart';
import 'package:flutter_application_1/page/level2/showpdf.dart';
import 'package:flutter_application_1/page/level2/account_new_cust.dart';
import 'package:flutter_application_1/page/level2/thirdTime.dart';
import 'package:flutter_application_1/page/level3/qmacceptlist.dart';
import 'package:flutter_application_1/page/level3/qmwating.dart';
import 'package:flutter_application_1/page/lm1/customercomemd.dart';
import 'package:flutter_application_1/page/lm1/frommediamd.dart';
import 'package:flutter_application_1/page/lm1/visitsitelm.dart';
import 'package:flutter_application_1/service/apiservice.dart';
import 'package:flutter_application_1/service/helper.dart';
import 'package:flutter_application_1/widget/header.dart';
import 'package:flutter_application_1/widget/notificationWidget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_application_1/maps/maps.dart';
import 'package:flutter_application_1/page/detailedit/detailedit.dart';

import 'package:flutter_application_1/page/level1/assignment/new_assignment.dart';
import 'package:flutter_application_1/page/level1/customercome/customercome.dart';
import 'package:flutter_application_1/page/level1/fromem/formold.dart';
import 'package:flutter_application_1/page/level1/fromem/fromagency/fromagency.dart';
import 'package:flutter_application_1/page/level1/visitsite.dart';
import 'package:flutter_application_1/page/level1/frommedia/media.dart';
import 'package:flutter_application_1/page/level1/waitAssign/new_acceptwait.dart';
import 'package:flutter_application_1/page/level1/waitAssign/Acceptwait.dart';
import 'package:flutter_application_1/page/level1/waitAssign/new_waitassign.dart';
import 'package:flutter_application_1/page/level1/waitAssign/waitassign.dart';
import 'package:flutter_application_1/page/level2/MD/new_getwaitFollowMD.dart';
import 'package:flutter_application_1/page/level2/MD/new_notget.dart';
import 'package:flutter_application_1/page/level2/MD/getwaitFollowMD.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  helper helperController = Get.put(helper());
  late dynamic empcode = 10000;
  late List lv3 = []; // กำหนดค่าเริ่มต้นเป็นลิสต์ว่าง ๆ
  @override
  void initState() {
    super.initState();
    employeesAll();
    getFollowlooptimes();
    getNotifications();
    helperController.getNotifications();
  }

  late List empdata = [];

  late dynamic followUpTimes = 3;
  Future<dynamic> employeesAll() async {
    try {
      final apiService = ApiService();
      dynamic apiResponse = await apiService.getEMPCODE();

      setState(() {
        empcode = apiResponse;
        lv3 = [
          {
            "routes":
                Qmwaiting(empcode: empcode.toString()), // Use named argument
            "svgIcon": "images/paper.svg",
            "title": "รอยืนยัน QM"
          },
          {
            "routes":
                Qmacceptlist(empcode: empcode.toString()), // Use named argument
            "svgIcon": "images/paper.svg",
            "title": "Backlogs"
          },
          // You can add more items here if needed
        ];
      });

      await getEmployees(apiResponse);
      // Access properties from the map directly
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> getFollowlooptimes() async {
    try {
      final apiService = ApiService();
      dynamic apiResponse = await apiService.getFollowlooptimes();

      // Check if apiResponse is not null and contains at least one element
      if (apiResponse != null && apiResponse.isNotEmpty) {
        setState(() {
          followUpTimes = apiResponse[0]['follow_up_times'] ?? 0;
        });
      } else {
        print('No data available.');
        setState(() {
          followUpTimes = 0; // or handle it accordingly
        });
      }
      // Access properties from the map directly
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<dynamic> getEmployees(dynamic empcode) async {
    try {
      final apiService = ApiService();
      dynamic apiResponse = await apiService.getEmployees(empcode);

      if (apiResponse.isNotEmpty && apiResponse[0].containsKey('position_id')) {
        setState(() {
          if (apiResponse[0]['position_id'] == "P00001") {
            data = [
              {
                "routes": VisiteSiteLM(
                  source_group_name: 5,
                  source_id: 9,
                  owner_source_id: 1,
                ),
                "svgIcon": "images/logo.svg",
                "title": "ลงพื้นที่"
              },
              {
                "routes": CustomerComeMD(),
                "svgIcon": "images/customercome.svg",
                "title": "ลูกค้าติดต่อเข้ามา"
              },
              {
                "routes": Frommediamd(),
                "svgIcon": "images/blackboard.svg",
                "title": "ค้นจากสื่อ"
              },
              {
                "routes": Formold(),
                "svgIcon": "images/start.svg",
                "title": "มีผู้แนะนำ"
              },
              {
                "routes": Fromagency(),
                "svgIcon": "images/people.svg",
                "title": "เอเจนซี่"
              },
              {
                "routes": NewAcceptwait(),
                "svgIcon": "images/waitassign.svg",
                "title": "งานรออนุมัติ"
              },
            ];
            dataFollow = [
              {
                "routes": NewnotGetMD(),
                "svgIcon": "images/firsteye.svg",
                "title": "ยังไม่ได้ติดตาม"
              },
              {
                "routes": NewgetwaitFollowMD(),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 1"
              },
            ];
          } else if (apiResponse[0]['position_id'] == "P00053" ||
              apiResponse[0]['position_id'] == "P00050") {
            data = [
              {
                "routes": VisiteSiteLM(
                  source_group_name: 5,
                  source_id: 10,
                  owner_source_id: 1,
                ),
                "svgIcon": "images/logo.svg",
                "title": "ลงพื้นที่"
              },
              {
                "routes": NewassignMent(),
                "svgIcon": "images/assinglogo.svg",
                "title": "งานมอบหมาย"
              },
              {
                "routes": CustomerComeMD(),
                "svgIcon": "images/customercome.svg",
                "title": "ลูกค้าติดต่อเข้ามา"
              },
              {
                "routes": Frommediamd(),
                "svgIcon": "images/blackboard.svg",
                "title": "ค้นจากสื่อ"
              },
              {
                "routes": Formold(),
                "svgIcon": "images/start.svg",
                "title": "มีผู้แนะนำ"
              },
              {
                "routes": Fromagency(),
                "svgIcon": "images/people.svg",
                "title": "เอเจนซี่"
              },
              {
                "routes": NewAcceptwait(),
                "svgIcon": "images/waitassign.svg",
                "title": "งานรออนุมัติ"
              },
              /*  {
                "routes": MapWidget(),
                "svgIcon": "images/waitassign.svg",
                "title": "เพิ่มแผนที่"
              }, */
            ];
            dataFollow = [
              {
                "routes": NewnotGetMD(),
                "svgIcon": "images/firsteye.svg",
                "title": "ยังไม่ได้ติดตาม"
              },
              {
                "routes": GetwaitFollowMD(),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 1"
              },
            ];
            for (int i = 2; i <= followUpTimes; i++) {
              dataFollow.add({
                "routes": newThirdTime(
                  Time: i.toString(),
                ),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ $i"
              });
            }
          } else if (apiResponse[0]['position_id'] == "P00054") {
            data = [
              {
                "routes": VisiteSiteLM(
                  source_group_name: 5,
                  source_id: 11,
                  owner_source_id: 1,
                ),
                "svgIcon": "images/logo.svg",
                "title": "ลงพื้นที่"
              },
              {
                "routes": CustomerComeMD(),
                "svgIcon": "images/customercome.svg",
                "title": "ลูกค้าติดต่อเข้ามา"
              },
              {
                "routes": Frommediamd(),
                "svgIcon": "images/blackboard.svg",
                "title": "ค้นจากสื่อ"
              },
              {
                "routes": Formold(),
                "svgIcon": "images/start.svg",
                "title": "มีผู้แนะนำ"
              },
              {
                "routes": Fromagency(),
                "svgIcon": "images/people.svg",
                "title": "เอเจนซี่"
              },
              {
                "routes": NewassignMent(),
                "svgIcon": "images/assinglogo.svg",
                "title": "งานมอบหมาย"
              },
              {
                "routes": NewAcceptwait(),
                "svgIcon": "images/waitassign.svg",
                "title": "งานรออนุมัติ"
              },
              /*  {
                "routes": MapWidget(),
                "svgIcon": "images/waitassign.svg",
                "title": "เพิ่มแผนที่"
              }, */
            ];
            dataFollow = [
              {
                "routes": NewnotGetMD(),
                "svgIcon": "images/firsteye.svg",
                "title": "ยังไม่ได้ติดตาม"
              },
              {
                "routes": NewgetwaitFollowMD(),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 1"
              },
              {
                "routes": newThirdTime(
                  Time: "2",
                ),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 2"
              },
            ];
            for (int i = 3; i <= followUpTimes; i++) {
              dataFollow.add({
                "routes": newThirdTime(
                  Time: i.toString(),
                ),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ $i"
              });
            }
          } else {
            data = [
              {
                "routes": VisitSite(
                  source_group_name: 1,
                  source_id: 1,
                  owner_source_id: 1,
                ),
                "svgIcon": "images/logo.svg",
                "title": "ลงพื้นที่"
              },
              {
                "routes": CustomerCome(),
                "svgIcon": "images/customercome.svg",
                "title": "ลูกค้าติดต่อเข้ามา"
              },
              {
                "routes": Media(),
                "svgIcon": "images/blackboard.svg",
                "title": "ค้นจากสื่อ"
              },
              {
                "routes": Formold(),
                "svgIcon": "images/start.svg",
                "title": "มีผู้แนะนำ"
              },
              {
                "routes": Fromagency(),
                "svgIcon": "images/people.svg",
                "title": "เอเจนซี่"
              },
              {
                "routes": NewassignMent(),
                "svgIcon": "images/assinglogo.svg",
                "title": "งานมอบหมาย"
              },
              {
                "routes": NewwaitAssign(),
                "svgIcon": "images/waitassign.svg",
                "title": "งานรอมอบหมาย"
              },
              {
                "routes": MapWidget(),
                "svgIcon": "images/waitassign.svg",
                "title": "เพิ่มแผนที่"
              },
            ];
            dataFollow = [
              {
                "routes": NewfirstTime(),
                "svgIcon": "images/firsteye.svg",
                "title": "ยังไม่ได้ติดตาม"
              },
              {
                "routes": NewsecondTime(),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 1"
              },
              {
                "routes": newThirdTime(
                  Time: "2",
                ),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ 2"
              }
              // {
              //   "routes": Showpdf(),
              //   "svgIcon": "images/firsteye.svg",
              //   "title": "PDF"
              // }
            ];
            for (int i = 3; i <= followUpTimes; i++) {
              dataFollow.add({
                "routes": newThirdTime(
                  Time: i.toString(),
                ),
                "svgIcon": "images/secondeye.svg",
                "title": "ติดตามครั้งที่ $i"
              });
            }
          }
        });
      }
      // Access properties from the map directly
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  final double topWidgetHeight = 112.0;
  int itemCount = 10;
  final double avatarRadius = 50.0;
  late List data = [];

  late List dataFollow = [];
  late List DetailFollow = [
    {
      "routes": DetailEdit(),
      "svgIcon": "images/detailfollow.svg",
      "title": "ข้อมูลการติดตาม"
    },
    {
      "routes": newCust(),
      "svgIcon": "images/groupAdd.svg",
      "title": "เปิดบัญชีลูกค้าใหม่"
    },
    {
      "routes": DetailEdit(),
      "svgIcon": "images/stylenew.svg",
      "title": "เปิดเครดิตลุกค้าใหม่"
    },
  ];
  late dynamic NotificationCount = 0;
  Future<void> getNotifications() async {
    try {
      final apiService = ApiService();
      dynamic apiData = await apiService.getCountNotifications();

      if (apiData != null) {
        setState(() {
          NotificationCount = apiData[0];
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: <Widget>[
          HeaderhomeWidget(
              topWidgetHeight: topWidgetHeight,
              avatarRadius: avatarRadius,
              empcode: empcode.toString(),
              version: helperController.version.value,
              count: NotificationCount),
          Positioned(
              width: MediaQuery.of(context).size.width,
              bottom: 20,
              top: topWidgetHeight +
                  avatarRadius -
                  0, // Adjust position as needed
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Level 1",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF054752)),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              child: Text(
                                "(การปฎิบัติงาน)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF054752)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.00, right: 10.00, top: 10.00),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 0.0),
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    children: List.generate(
                                      data.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        data[index]['routes']));
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip
                                                    .none, // Allows the badge to overflow if necessary
                                                children: [
                                                  NotificationWidget(
                                                      title: data[index]
                                                          ['title'],
                                                      count: NotificationCount),
                                                  Positioned(
                                                    child: ClipOval(
                                                      child: Container(
                                                        padding: EdgeInsets.all(
                                                            12.0),
                                                        child: SvgPicture.asset(
                                                          '${data[index]['svgIcon']}',
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              5.5, // Adjust width as needed
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              7, // Adjust height as needed
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                data[index]['title'],
                                                style:
                                                    TextStyle(fontSize: 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Level 2",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF054752)),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              child: Text(
                                "(การติดตามลูกค้า)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF054752)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.00, right: 10.00, top: 10.00),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 0.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        children: List.generate(
                                          dataFollow.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.only(
                                                left: 3, right: 5, top: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Handle tap event, for example navigate to route
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            dataFollow[index]
                                                                ['routes']));
                                              },
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    clipBehavior: Clip
                                                        .none, // Allows the badge to overflow if necessary
                                                    children: [
                                                      NotificationWidget(
                                                        title: dataFollow[index]
                                                            ['title'],
                                                        count:
                                                            NotificationCount,
                                                      ),
                                                      ClipOval(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            '${dataFollow[index]['svgIcon']}',
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5.5, // Adjust width as needed
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                7, // Adjust height as needed
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    dataFollow[index]['title'],
                                                    style: TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Wrap(
                                        children: List.generate(
                                          DetailFollow.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.only(
                                                left: 3, right: 5, top: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                // Handle tap event, for example navigate to route
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailFollow[index]
                                                                ['routes']));
                                              },
                                              child: Column(
                                                children: [
                                                  Stack(
                                                    clipBehavior: Clip
                                                        .none, // Allows the badge to overflow if necessary
                                                    children: [
                                                      NotificationWidget(
                                                        title:
                                                            DetailFollow[index]
                                                                ['title'],
                                                        count:
                                                            NotificationCount,
                                                      ),
                                                      ClipOval(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  12.0),
                                                          child:
                                                              SvgPicture.asset(
                                                            '${DetailFollow[index]['svgIcon']}',
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                5.5, // Adjust width as needed
                                                            height: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                7, // Adjust height as needed
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    DetailFollow[index]
                                                        ['title'],
                                                    style: TextStyle(
                                                        fontSize: 10.0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, top: 10),
                      child: Row(
                        children: [
                          Container(
                            child: Text(
                              "Level 3",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF054752)),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Container(
                              child: Text(
                                "(เสนอราคา)",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF054752)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 6,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.00, right: 10.00, top: 10.00),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          child: Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0.0, left: 10.0, right: 0.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Wrap(
                                    children: List.generate(
                                      lv3.length,
                                      (index) => Padding(
                                        padding: EdgeInsets.only(
                                            left: 3, right: 5, top: 5),
                                        child: GestureDetector(
                                          onTap: () {
                                            // Handle tap event, for example navigate to route
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        lv3[index]['routes']));
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                clipBehavior: Clip
                                                    .none, // Allows the badge to overflow if necessary
                                                children: [
                                                  NotificationWidget(
                                                    title: lv3[index]['title'],
                                                    count: NotificationCount,
                                                  ),
                                                  ClipOval(
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      child: SvgPicture.asset(
                                                        '${lv3[index]['svgIcon']}',
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            5.5, // Adjust width as needed
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            7, // Adjust height as needed
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                lv3[index]['title'],
                                                style:
                                                    TextStyle(fontSize: 10.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
