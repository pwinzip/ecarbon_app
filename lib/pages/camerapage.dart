import 'dart:async';

import 'package:camera/camera.dart';
import 'package:ecarbon/pages/cal_heightpage.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math' as math;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key, required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  bool _isCameraInitialized = false;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  double? xInclination;
  double? yInclination;
  double? zInclination;

  int _step = 0;
  String bottomText = "ขั้นตอนที่ 1 ถ่ายภาพที่โคนต้นไม้";

  double? topDegree;
  double? bottomDegree;

  Duration sensorInterval = SensorInterval.normalInterval;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.max,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    // // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = controller!.value.isInitialized;
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  initSensorListener() {
    if (!mounted) {
      return;
    }
    _streamSubscriptions.add(
      accelerometerEventStream(samplingPeriod: sensorInterval).listen(
        (AccelerometerEvent event) {
          setState(() {
            // _accelerometerValues = <double>[event.x, event.y, event.z];
            // Calculate angle
            double x = event.x, y = event.y, z = event.z;
            double normOfG = math.sqrt(
                event.x * event.x + event.y * event.y + event.z * event.z);
            x = event.x / normOfG;
            y = event.y / normOfG;
            z = event.z / normOfG;

            xInclination = -(math.asin(x) * (180 / math.pi));
            yInclination = (math.acos(y) * (180 / math.pi));
            zInclination = (math.atan(z) * (180 / math.pi));
          });
        },
        onError: (e) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Sensor Not Found"),
                  content: Text(
                      "It seems that your device doesn't support Accelerometor Sensor"),
                );
              });
        },
        cancelOnError: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    onNewCameraSelected(widget.cameras[0]);
    initSensorListener();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isCameraInitialized
          ? Column(
              children: [
                AspectRatio(
                  aspectRatio: 1 / controller!.value.aspectRatio,
                  child: Stack(
                    children: [
                      // CameraPreview(controller!),
                      controller!.buildPreview(),
                      Positioned(
                          top: screenHeight * 0.5, child: drawHorizontalLine()),
                      createDegreeText(),
                      createCaptureButton(),
                      createNextButton(),
                    ],
                  ),
                ),
                createBottomText(),
              ],
            )
          : Container(),
    );
  }

  Expanded createBottomText() {
    return Expanded(
      child: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            bottomText,
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Align createNextButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: _step == 2
                    ? MaterialStateProperty.all(
                        const Color.fromARGB(255, 17, 162, 135))
                    : MaterialStateProperty.all(
                        const Color.fromARGB(255, 120, 121, 121)),
              ),
              onPressed: _step == 2
                  ? () {
                      if (mounted) setState(() {});
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CalHeightPage(
                              bottomDegree: bottomDegree,
                              topDegree: topDegree,
                              cameras: widget.cameras,
                            ),
                          ));
                    }
                  : null,
              child: const Text(
                "ถัดไป",
                style: TextStyle(color: Colors.white),
              )),
        ),
      ),
    );
  }

  Align createCaptureButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: _step < 2
              ? () {
                  print(yInclination);
                  print(zInclination);
                  print("---------------");
                  if (_step == 1) {
                    setState(() {
                      topDegree = zInclination! >= 0
                          ? 90 - yInclination!
                          : 90 + yInclination!;
                      _step = 2;
                      bottomText = "กดถัดไป เพื่อคำนวณความสูง";
                      // topDegree = yInclination;
                    });
                    print("second capture");
                    print(topDegree);
                  } else if (_step == 0) {
                    setState(() {
                      _step = 1;
                      bottomText = "ขั้นตอนที่ 2 ถ่ายภาพที่ยอดต้นไม้";
                      bottomDegree = zInclination! >= 0
                          ? 90 - yInclination!
                          : 90 + yInclination!;
                      // bottomDegree = yInclination;
                      print("first capture");
                      print(bottomDegree);
                    });
                  } else if (_step == 2) {
                    setState(() {
                      _step = 3;
                    });
                  }
                }
              : null,
          style: _step < 2
              ? ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(
                          255, 3, 111, 179)), // <-- Button color
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.lightBlue; // <-- Splash color
                    }
                    return null;
                  }),
                )
              : ButtonStyle(
                  shape: MaterialStateProperty.all(const CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(
                          255, 224, 224, 224)), // <-- Button color
                  overlayColor:
                      MaterialStateProperty.resolveWith<Color?>((states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.lightBlue; // <-- Splash color
                    }
                    return null;
                  }),
                ),
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Align createDegreeText() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.only(top: 40.0, left: 20.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: zInclination! >= 0
            ? Text(
                "${90 - yInclination!.round()}°",
                style: const TextStyle(color: Colors.black),
              )
            : Text(
                "${90 + yInclination!.round()}°",
                style: const TextStyle(color: Colors.black),
              ),
      ),
    );
  }

  Widget drawHorizontalLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        height: 1.5,
        width: MediaQuery.of(context).size.width,
        color: Colors.red,
      ),
    );
  }
}
