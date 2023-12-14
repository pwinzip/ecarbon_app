import 'package:ecarbon/utils.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ForestTab extends StatefulWidget {
  const ForestTab({super.key});

  @override
  State<ForestTab> createState() => _ForestTabState();
}

class _ForestTabState extends State<ForestTab>
    with AutomaticKeepAliveClientMixin<ForestTab> {
  final _forestFormKey = GlobalKey<FormState>();
  final TextEditingController _heightForestTree = TextEditingController();
  final TextEditingController _circumferenceForestTree =
      TextEditingController();

  double forestCarbonResult = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    _heightForestTree.dispose();
    _circumferenceForestTree.dispose();
  }

  calForestCarbon() {
    num stem, branch, leaf, root;
    double H, D;

    H = double.parse(_heightForestTree.text);
    D = double.parse(_circumferenceForestTree.text) / math.pi;
    num x = math.pow(D, 2) * H;

    stem = (0.0396 * math.pow(x, 0.9326));
    branch = (0.006003 * math.pow(x, 1.0270));
    leaf = math.pow(((28.0 / (stem + branch)) + 0.025), -1);
    root = (0.0264 * math.pow(x, 0.7750));

    setState(() {
      forestCarbonResult = (stem.toDouble() +
              branch.toDouble() +
              leaf.toDouble() +
              root.toDouble()) *
          (47.00 / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Form(
        key: _forestFormKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text("กรุณาใส่ความสูงของต้นไม้ และเส้นรอบวง"),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "ความสูงของต้นไม้",
                      textAlign: TextAlign.start,
                    ),
                  ),
                  buildNumberInput(context, _heightForestTree, "เมตร"),
                ],
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
                      context, _circumferenceForestTree, "เซนติเมตร"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    calForestCarbon();
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
                      forestCarbonResult.toStringAsFixed(2),
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
