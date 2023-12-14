import 'package:camera/camera.dart';
import 'package:ecarbon/pages/firstpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.promptTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF91CA6B)),
        useMaterial3: true,
      ),
      home: FirstPage(cameras: cameras),
    );
  }
}
