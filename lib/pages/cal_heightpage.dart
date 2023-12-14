import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;

class CalHeightPage extends StatefulWidget {
  const CalHeightPage(
      {super.key, this.topDegree, this.bottomDegree, required this.cameras});

  final double? bottomDegree;
  final double? topDegree;
  final List<CameraDescription> cameras;

  @override
  State<CalHeightPage> createState() => _CalHeightPageState();
}

class _CalHeightPageState extends State<CalHeightPage> {
  double hTree = 0;
  num T = 0;
  int height = 175;
  int steps = 11;

  calulateTreeHeight() {
    // version 2
    print("bottomDegree: ${widget.bottomDegree}");
    print("topDegree: ${widget.topDegree}");
    double hc = 0;
    int n = steps;
    double d = 0;
    double L = 0;
    double H = height.toDouble() / 100; // convert to meters
    double? D = widget.bottomDegree; // Degree
    double? B = 90 - D!; // Degree
    double? A = widget.topDegree! - 90; // Degree

    L = H * 0.413;
    d = n * L;
    hc = H - 0.1014;

    // arc sine return in radians
    // sine need parameter in radians
    double radD = degree2Radians(D);
    double radB = degree2Radians(B);
    double radA = degree2Radians(A);
    print("radian D: $radD");
    print("radian B: $radB");
    print("radian A: $radA");
    print("math.sin(rad_D): ${math.sin(radD)}");
    print("H * math.sin(rad_D) / d: ${H * math.sin(radD) / d}");
    print("****************");
    double? E = math.asin(H * math.sin(radD) / d); // radians

    print("E: $E");

    double? F = D + radians2Degree(E); // degree
    double? f = d * math.sin(degree2Radians(F));
    double? t1 = f * math.tan(radB);
    double? t2 = f * math.tan(radA);

    setState(() {
      hTree = t1 + t2;
    });
    print("version 2");
    print("D (bottom) = $D");
    print("B (90-D) = $B");
    print("A (top) = $A");
    print("L = $L");
    print("d = $d");
    print("hc = $hc");
    print("E = $E");
    print("F = $F");
    print("f = $f");
    print("t1 = $t1");
    print("t2 = $t2");
    print("hTree = $hTree");
    print("-----------");
  }

  double degree2Radians(double deg) {
    return deg * (math.pi / 180);
  }

  double radians2Degree(double rad) {
    return (rad * 180) / math.pi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReusableCard(
                colour: const Color(0xFF36BEBE),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'ส่วนสูง',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFFF3F3F4),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: <Widget>[
                        Text(
                          height.toString(),
                          style: const TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'cm',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Color(0xFFF3F3F4),
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbColor: const Color(0xFFEB1555),
                        activeTrackColor: Colors.white,
                        thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 15.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 30),
                        overlayColor: const Color(0x29EB1555),
                      ),
                      child: Slider(
                        value: height.toDouble(),
                        min: 120.0,
                        max: 220.0,
                        inactiveColor: const Color(0xFF8D8E98),
                        onChanged: (double newValue) {
                          setState(() {
                            height = newValue.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              ReusableCard(
                colour: const Color(0xFF91CA6B),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'จำนวนก้าว',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFFF3F3F4),
                      ),
                    ),
                    Text(
                      steps.toString(),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RoundIconButton(
                            icon: FontAwesomeIcons.minus,
                            onPressed: () {
                              setState(() {
                                if (steps > 0) {
                                  steps--;
                                }
                              });
                            }),
                        const SizedBox(width: 10.0),
                        RoundIconButton(
                          icon: FontAwesomeIcons.plus,
                          onPressed: () {
                            setState(() {
                              steps++;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonTitle: 'คำนวณความสูง',
                bgColor: const Color.fromARGB(255, 235, 66, 117),
                onTap: () {
                  print("คำนวณ");
                  calulateTreeHeight();
                },
              ),
              ReusableCard(
                colour: const Color(0xFFDAD9D9),
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'ความสูงของต้นไม้',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF282828),
                      ),
                    ),
                    Text(
                      hTree.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 50,
                        color: Color(0xFF000000),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Text(
                      'เมตร',
                      style: TextStyle(
                        fontSize: 22.0,
                        color: Color(0xFF282828),
                      ),
                    ),
                  ],
                ),
              ),
              BottomButton(
                buttonTitle: 'กลับหน้าหลัก',
                bgColor: const Color.fromARGB(255, 64, 113, 227),
                onTap: () {
                  Navigator.of(context).pop();
                  // Navigator.pushReplacement(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) =>
                  //           UserHomePage(cameras: widget.cameras),
                  //     ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReusableCard extends StatelessWidget {
  const ReusableCard({
    super.key,
    required this.colour,
    required this.cardChild,
  });
  final Color colour;
  final Widget cardChild;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colour,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: cardChild,
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton(
      {super.key, required this.icon, required this.onPressed});

  final IconData icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFFF3F3F4),
      child: Icon(icon),
    );
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton(
      {super.key,
      required this.onTap,
      required this.buttonTitle,
      required this.bgColor});

  final Function() onTap;
  final String buttonTitle;
  final Color bgColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: bgColor,
        margin: const EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: 50.0,
        child: Center(
            child: Text(
          buttonTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}
