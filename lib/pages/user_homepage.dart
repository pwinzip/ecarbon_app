import 'package:camera/camera.dart';
import 'package:ecarbon/pages/cal_carbonpage.dart';
import 'package:ecarbon/pages/camerapage.dart';
import 'package:ecarbon/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppbar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              // แสดงจำนวน คาร์บอร์เครดิตรวมทั้งหมดที่มี
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text(
                  "ปริมาณคาร์บอนกักเก็บที่มีทั้งหมด",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                  textAlign: TextAlign.left,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF028391), Color(0xFF00BCB2)]),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 3,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        NumberFormat.decimalPattern("en_us").format(2450),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "กิโลกรัม",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 252, 252),
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              createGridMenu(context),
            ],
          ),
        ),
      ),
    );
  }

  GridView createGridMenu(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.all(6),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: [
        // createCalHeightButton(context),
        // createCalCarbonButton(context),
        createMenuButton(
          context,
          MaterialPageRoute(
            builder: (context) => CameraPage(cameras: widget.cameras),
          ),
          [const Color(0xFF8BCFD8), const Color(0xFFBADD96)],
          "assets/images/tree.png",
          "คำนวณความสูงของต้นไม้",
        ),
        createMenuButton(
          context,
          MaterialPageRoute(
            builder: (context) => const CalCarbonPage(),
          ),
          [const Color(0xFF8BCFD8), const Color(0xFFBADD96)],
          "assets/images/plant-2.png",
          "คำนวณปริมาณคาร์บอน",
        ),
        // บันทึก
        // หน้าบันทึก จะมีให้เลือก ว่าจะบันทึกแบบรายต้น หรือทั้งแปลง
        // เลือกชนิดต้นไม้ที่ต้องการบันทึก
        // แสดงค่าการคำนวณ ของที่แต่ละชนิด แล้วกดบันทึก
        createMenuButton(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(cameras: widget.cameras),
            ),
            [const Color(0xFF8BCFD8), const Color(0xFFBADD96)],
            "assets/images/save-data.png",
            "บันทึกข้อมูลปริมาณคาร์บอน",
            imgHeight: 90),
        // มีหน้าแสดงประวัติ การบันทึก โดยแสดงวันที่ เวลา ประเภทต้นไม้ จำนวนต้น
        // ละติจูด ลองติจูด และปริมาณคาร์บอน
        createMenuButton(
            context,
            MaterialPageRoute(
              builder: (context) => CameraPage(cameras: widget.cameras),
            ),
            [const Color(0xFF8BCFD8), const Color(0xFFBADD96)],
            "assets/images/history.jpg",
            "ประวัติการบันทึกข้อมูล",
            imgHeight: 100),
      ],
    );
  }

  InkWell createMenuButton(BuildContext context, MaterialPageRoute route,
      List<Color> gradient, String imgPath, String title,
      {double imgHeight = 90}) {
    return InkWell(
      onTap: () {
        print("menu btn $title");
        Navigator.push(context, route);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: imgHeight,
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
