import 'package:ecarbon/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class BambooTab extends StatefulWidget {
  const BambooTab({super.key});

  @override
  State<BambooTab> createState() => _BambooTabState();
}

class _BambooTabState extends State<BambooTab>
    with AutomaticKeepAliveClientMixin<BambooTab> {
  final _bambooFormKey = GlobalKey<FormState>();
  final TextEditingController _circumferenceBambooTree =
      TextEditingController();
  double bamboCarbonResult = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _circumferenceBambooTree.dispose();
  }

  calBambooCarbon() {
    double D;
    D = double.parse(_circumferenceBambooTree.text) / math.pi;
    setState(() {
      bamboCarbonResult = (0.639 * math.pow(D, 1.6162)) * (47.00 / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Form(
        key: _bambooFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("กรุณาใส่เส้นรอบวงของต้นไม้"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "เส้นรอบวงของต้นไม้",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  buildNumberInput(
                      context, _circumferenceBambooTree, "เซนติเมตร"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    calBambooCarbon();
                  },
                  child: const Text("คำนวณปริมาณคาร์บอน"),
                ),
              ),
              ReusableGradientCard(
                colour: const [Color(0xFF8BCFD8), Color(0xFFBADD96)],
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ปริมาณคาร์บอนกักเก็บ',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Text(
                      bamboCarbonResult.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'กิโลกรัม',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color.fromRGBO(62, 62, 62, 1),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
