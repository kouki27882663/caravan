import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gazou/outblaze.dart';
import 'package:gazou/main.dart';
import 'package:quiver/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gazou/pause.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';


/// 写真撮影画面
class Landmark extends StatefulWidget {
  const Landmark({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  LandmarkState createState() => LandmarkState();
}

class LandmarkState extends State<Landmark> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();


  @override
  void initState() {
    super.initState();

    _controller = CameraController(
      // カメラを指定
      widget.camera,
      // 解像度を定義
      ResolutionPreset.medium,
    );

    // コントローラーを初期化
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // ウィジェットが破棄されたら、コントローラーを破棄
    _controller.dispose();
    super.dispose();
  }




  Widget build(BuildContext context) {
    if (count == 0) {
      _audio.play('syoumen.mp3');
      count++;
    }
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        fit:StackFit.loose,
        children: [
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CameraPreview(_controller);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Container(
            padding: const EdgeInsets.only(top: 55),
            alignment: Alignment.topCenter,
            child: const Text('正面を向いてください', style: TextStyle(fontSize: 36,backgroundColor: Colors.orange ,color: Colors.white)),
          ),
          Opacity(
            opacity: check ? opacity = 0.6 : opacity = 0.6,
            child: Image.asset("assets/1.png"),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:620,right: 150),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:620,left: 30),
                
                child: FloatingActionButton(
                  onPressed: () async {
                    // 写真を撮る
                    final image = await _controller.takePicture();

                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazeLandmarkPage(imagePath:image.path,camera:widget.camera),
              )
                    );
                    // path を出力
                  },
                  child: const Icon(Icons.camera_alt),
                ),
                ),
              ],
        ),
        ],
      ),
    );
  }
}

class BlazeLandmarkPage extends StatefulWidget {
  const BlazeLandmarkPage({Key? key, required this.camera, required this.imagePath,})
      : super(key: key);
  final CameraDescription camera;
  final String imagePath;
  @override
  State<BlazeLandmarkPage> createState() => BlazeLandmarkPageState();
}

class BlazeLandmarkPageState extends State<BlazeLandmarkPage> {
  final _audio = AudioCache();
  bool _fileSelected = false;
  bool _poseFound = false;
  var listx = [];
  var listy = [];
  bool hantei = true;
  bool hantei2 = true;
  int count = 0;

  String? _extension;
  String? _fileName;
  File? _filePath;
  var offsets = <Offset>[];

  final _points = <Offset>[];

  final poseDetector = PoseDetector(options: PoseDetectorOptions());
  Future<void> _blazePose() async {
    String path_1 = widget.imagePath; //
    final inputImage = InputImage.fromFilePath(path_1);
    final List<Pose> poses = await poseDetector.processImage(inputImage);

    //デバイスのサイズ取得
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;

    
    //初期化
    listx = [];
    listy = [];

    for (Pose pose in poses) {
      // to access all landmarks
      pose.landmarks.forEach((_, landmark) {
        //比率を合わせる
        offsets.add(Offset(landmark.x/480*deviceWidth, landmark.y/960*deviceHeight));
        // print("${landmark.type}, x=${landmark.x}, y=${landmark.y}");

        listx.add(landmark.x);
        listy.add(landmark.y);
      });
    }
    setState(() {
      _poseFound = true;
    });
  }

 // 点を追加
  void _addPoint(TapDownDetails details) {
    // setState()にリストを更新する関数を渡して状態を更新
    setState(() {
      _points.add(details.localPosition);
      // details.localPositionが座標値
      print(details.localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      _blazePose();
      count++;
    }
    
    return Scaffold(
      //撮った写真を表示
      //appBar: AppBar(title: const Text('姿勢推定出力')),
      body: Stack(
        children: <Widget>[
          Image.file(
            File(widget.imagePath)
          ),
          GestureDetector(
          // カスタムペイント
          child: CustomPaint(
            painter: MyPainter(offsets),
            // タッチを有効にするため、childが必要
            child: Center(),
        ),
      ),
      ],
          ),
      // body: Center(child: Transform(transform: Matrix4.rotationY(pi),
      // child: Image.file(File(widget.imagePath)),
      // )
      // ),
    );
  }
}
class MyPainter extends CustomPainter{
  final List<Offset> offsets;

  MyPainter(this.offsets);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.red;
    final radius = size.width / 50;
    print(offsets);


    final Nose = offsets[0];
    final Left_eye_inner = offsets[1];
    final Left_eye = offsets[2];
    final Left_eye_outer = offsets[3];
    final Right_eye_inner = offsets[4];
    final Right_eye = offsets[5];
    final Right_eye_outer = offsets[6];
    final Left_ear = offsets[7];
    final Right_ear = offsets[8];
    final Left_mouth = offsets[9];
    final Right_mouth = offsets[10];
    final Left_shoulder = offsets[11];
    final Right_shoulder = offsets[12];
    final Left_elbow = offsets[13];
    final Right_elbow = offsets[14];
    final Left_wrist = offsets[15];
    final Right_wrist = offsets[16];
    final Left_pinky = offsets[17];
    final Right_pinky = offsets[18];
    final Left_index = offsets[19];
    final Right_index = offsets[20];
    final Left_thumb = offsets[21];
    final Right_thumb = offsets[22];
    final Left_hip = offsets[23];
    final Right_hip = offsets[24];
    final Left_knee = offsets[25];
    final Right_knee = offsets[26];
    final Left_ankle = offsets[27];
    final Right_ankle = offsets[28];
    final Left_heel = offsets[29];
    final Right_heel = offsets[30];
    final Left_foot_index = offsets[31];
    final Right_foot_index = offsets[32];
    
    paint.color = Colors.orange;
    canvas.drawCircle(Nose, radius, paint);
    canvas.drawCircle(Left_shoulder, radius, paint);
    canvas.drawCircle(Right_shoulder, radius, paint);
    canvas.drawCircle(Left_elbow, radius, paint);
    canvas.drawCircle(Right_elbow, radius, paint);
    canvas.drawCircle(Left_wrist, radius, paint);
    canvas.drawCircle(Right_wrist, radius, paint);
    canvas.drawCircle(Left_hip, radius, paint);
    canvas.drawCircle(Right_hip, radius, paint);
    canvas.drawCircle(Left_eye, radius, paint);
    canvas.drawCircle(Right_eye, radius, paint);
    canvas.drawCircle(Left_mouth, radius, paint);
    canvas.drawCircle(Right_mouth, radius, paint);
    
    paint.strokeWidth = 5;
    paint.color = Colors.green;
    canvas.drawLine(Left_mouth, Right_mouth, paint);
    canvas.drawLine(Right_shoulder, Left_shoulder, paint);
    canvas.drawLine(Right_shoulder, Right_elbow, paint);
    canvas.drawLine(Left_shoulder, Left_elbow, paint);
    canvas.drawLine(Left_elbow, Left_wrist, paint);
    canvas.drawLine(Right_elbow, Right_wrist, paint);
    canvas.drawLine(Left_shoulder, Left_hip, paint);
    canvas.drawLine(Right_shoulder, Right_hip, paint);
    canvas.drawLine(Right_hip, Left_hip, paint);

  }

  // void paint(Canvas canvas, Size size) {
  //   // 記憶している点を描画する
  //   _points.forEach((offset) =>
  //       // canvas.drawRect(Rect.fromCenter(center: offset, width: 20.0, height: 20.0), _rectPaint));
  //       canvas.drawCircle(offset, 10, _rectPaint)); 
  // }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

