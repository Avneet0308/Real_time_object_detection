import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;
import 'package:url_launcher/url_launcher.dart';
import 'camera.dart';
import 'bndbox.dart';

const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";

class HomePage extends StatefulWidget {



  final List<CameraDescription> cameras;

  HomePage(this.cameras);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = "";



  @override
  void initState() {
    super.initState();
  }

  loadModel() async {
    String res;
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;
      default:
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
        break;
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model;
    });
    loadModel();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      /*drawer: _model == ""
          ? new Drawer(
        child: new Text("\n\n\nDrawer Is Here"),

      ):null,*/
      appBar: _model == ""
          ?AppBar(
        title: Text("Real Time Object Detection"),
        backgroundColor: Color(0xff0064b7),
      ):null,
      body: _model == ""
          ? Container(
              margin: EdgeInsets.only(left: 20.0,right: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Card(
                    elevation: 20.0,
                    color: Color(0xff0091ea),
                child: Column(

                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const ListTile(
                    leading: Icon(Icons.album),
                    title: Text(ssd),
                    subtitle: Text('Faster but Overtrained'),

                  ),
                  ButtonBar(
                      children: <Widget>[
                        RaisedButton(
                          color: Color(0xff64c1ff),
                          child: const Text('Try it'),
                          onPressed: ()=> onSelect(ssd),
                        ),
                        RaisedButton(
                          color: Color(0xff64c1ff),
                          child: const Text('Know more'),
                          onPressed: ()=>_launchURL1(),
                        ),
                      ],
                    ),
                ],
              ),

                  ),

                  Container(
                    height: 50.0,
                  ),


                  Card(
                    elevation: 20.0,
                    color: Color(0xff0091ea),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const ListTile(
                          leading: Icon(Icons.album),
                          title: Text(yolo),
                          subtitle: Text('Slower but accurate'),
                        ),
                        ButtonBar(
                            children: <Widget>[
                              RaisedButton(
                                color: Color(0xff64c1ff),
                                child: const Text('Try it'),
                                onPressed: ()=> onSelect(yolo),
                              ),
                              RaisedButton(
                                color: Color(0xff64c1ff),
                                child: const Text('Know more'),
                                onPressed: ()=>_launchURL2(),
                              ),
                            ],
                          ),

                      ],
                    ),

                  ),


                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                  _recognitions == null ? [] : _recognitions,
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                ),
              ],
            ),
    );
  }
}

_launchURL1() async {
  const url = 'https://medium.com/@smallfishbigsea/understand-ssd-and-implement-your-own-caa3232cd6ad';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL2() async {
  const url = 'https://pjreddie.com/darknet/yolo/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}