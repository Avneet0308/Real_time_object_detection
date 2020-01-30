import 'dart:async';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:camera/camera.dart';
import 'home.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: true,
    title: 'tflite real-time detection',
    home: MyApp(),
  )
  );
}


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => new MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        seconds: 5,
        navigateAfterSeconds: new HomePage(cameras),
        title: new Text('Real Time Object Detection',
          style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
              color: Colors.teal


          ),),
        image: new Image.asset('assets/SplashScreen.png'),
        backgroundColor: Colors.white,
        styleTextUnderTheLoader: new TextStyle(),
        photoSize: 150.0,
        onClick: ()=>print("Flutter Egypt"),
        loaderColor: Colors.tealAccent
    );
  }
}


