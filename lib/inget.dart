import 'dart:io';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gazou/inblaze.dart';
import 'package:gazou/main.dart';
import 'package:quiver/async.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:gazou/pause.dart';

//get0
/// 写真撮影画面
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 10;
  int _current = 10;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage1(imagePath:image.path,camera:widget.camera),
              )
                    );
    });
  }


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
      _audio.play('zensin.mp3');
      startTimer();
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
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
              ),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause1Page(title:"中断中",camera:widget.camera),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
    );
  }
}

//get1
/// 写真撮影画面
class TakePictureScreen1 extends StatefulWidget {
  const TakePictureScreen1({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreen1State createState() => TakePictureScreen1State();
}

class TakePictureScreen1State extends State<TakePictureScreen1> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 5;
  int _current = 5;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage1(imagePath:image.path,camera:widget.camera),
              )
                    );
    });
  }


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
      startTimer();
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
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause1Page(title:"中断中",camera:widget.camera),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}

/// 写真撮影画面
class TakePictureScreen1p1 extends StatefulWidget {
  const TakePictureScreen1p1({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreen1p1State createState() => TakePictureScreen1p1State();
}

class TakePictureScreen1p1State extends State<TakePictureScreen1p1> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 10;
  int _current = 10;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage1(imagePath:image.path,camera:widget.camera),
              )
                    );
    });
  }


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
      startTimer();
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
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause1Page(title:"中断中",camera:widget.camera),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}

//get2
/// 写真撮影画面
class TakePictureScreen2 extends StatefulWidget {
  const TakePictureScreen2({
    Key? key,
    required this.camera,
    required this.path1,
  }) : super(key: key);

  final CameraDescription camera;
  final String path1;

  @override
  TakePictureScreen2State createState() => TakePictureScreen2State();
}

class TakePictureScreen2State extends State<TakePictureScreen2> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 5;
  int _current = 5;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage2(imagePath:image.path,camera:widget.camera,path1: widget.path1),
              )
                    );
    });
  }


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
      _audio.play('migi.mp3');
      startTimer();
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
            child: const Text('右を向いてください', style: TextStyle(fontSize: 36,backgroundColor: Colors.orange ,color: Colors.white)),
          ),          
          Opacity(
            opacity: check ? opacity = 0.6 : opacity = 0.6,
            child: Image.asset("assets/2.png"),
          ),
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause2Page(title:"中断中",camera:widget.camera,path1:widget.path1),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}

class TakePictureScreen2p2 extends StatefulWidget {
  const TakePictureScreen2p2({
    Key? key,
    required this.camera,
    required this.path1,
  }) : super(key: key);

  final CameraDescription camera;
  final String path1;

  @override
  TakePictureScreen2p2State createState() => TakePictureScreen2p2State();
}

class TakePictureScreen2p2State extends State<TakePictureScreen2p2> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 10;
  int _current = 10;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage2(imagePath:image.path,camera:widget.camera,path1: widget.path1),
              )
                    );
    });
  }


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
      _audio.play('migi.mp3');
      startTimer();
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
            child: const Text('右を向いてください', style: TextStyle(fontSize: 36,backgroundColor: Colors.orange ,color: Colors.white)),
          ),          
          Opacity(
            opacity: check ? opacity = 0.6 : opacity = 0.6,
            child: Image.asset("assets/2.png"),
          ),
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause2Page(title:"中断中",camera:widget.camera,path1:widget.path1),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}

//get3
/// 写真撮影画面
class TakePictureScreen3 extends StatefulWidget {
  const TakePictureScreen3({
    Key? key,
    required this.camera,
    required this.path1,
    required this.path2,
  }) : super(key: key);

  final CameraDescription camera;
  final String path1;
  final String path2;

  @override
  TakePictureScreen3State createState() => TakePictureScreen3State();
}

class TakePictureScreen3State extends State<TakePictureScreen3> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 5;
  int _current = 5;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage3(imagePath:image.path,camera:widget.camera,path1:widget.path1,path2:widget.path2),
              )
                    );
    });
  }


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
      _audio.play('hidari.mp3');
      startTimer();
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
            child: const Text('左を向いてください', style: TextStyle(fontSize: 36,backgroundColor: Colors.orange ,color: Colors.white)),
          ),          
          Opacity(
            opacity: check ? opacity = 0.6 : opacity = 0.6,
            child: Image.asset("assets/3.png"),
          ),
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause3Page(title:"中断中",camera:widget.camera,path1:widget.path1,path2:widget.path2),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}

class TakePictureScreen3p3 extends StatefulWidget {
  const TakePictureScreen3p3({
    Key? key,
    required this.camera,
    required this.path1,
    required this.path2,
  }) : super(key: key);

  final CameraDescription camera;
  final String path1;
  final String path2;

  @override
  TakePictureScreen3p3State createState() => TakePictureScreen3p3State();
}

class TakePictureScreen3p3State extends State<TakePictureScreen3p3> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool check = true;
  double opacity = 0.5;
  int _start = 10;
  int _current = 10;
  int tmp = 0;
  int count = 0;
  final _audio = AudioCache();

  // ③ カウントダウン処理を行う関数を定義
  Future <void> startTimer() async{
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds; //毎秒減らしていく
      });
    });
    // ④終了時の処理
    sub.onDone(()async {
      final image = await _controller.takePicture();

      await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BlazePage3(imagePath:image.path,camera:widget.camera,path1:widget.path1,path2:widget.path2),
              )
                    );
    });
  }


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
      _audio.play('hidari.mp3');
      startTimer();
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
            child: const Text('左を向いてください', style: TextStyle(fontSize: 36,backgroundColor: Colors.orange,color: Colors.white)),
          ),          
          Opacity(
            opacity: check ? opacity = 0.6 : opacity = 0.6,
            child: Image.asset("assets/3.png"),
          ),
          Opacity(
            opacity: check ? opacity = 0.5 : opacity = 0.5,
            child: Container(
              alignment: Alignment.center,
              child: Text(
              "$_current",
              style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 300,
              color: Color.fromARGB(255, 50, 51, 51),
              ),
            ),
          ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top:720,right: 20),
                child:FloatingActionButton(
                  onPressed: (){
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                  },
                  child: const Icon(Icons.home),
                ),
                ),
                Padding(padding: const EdgeInsets.only(top:720,left: 30),
                child:ElevatedButton(
                  onPressed: (){
                    dispose();
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Pause3Page(title:"中断中",camera:widget.camera,path1:widget.path1,path2:widget.path2),
              )
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    elevation: 16,
                  ),
                  child: const Text('中断する',style: TextStyle(fontSize: 50,color: Colors.white)),
                ),
                )
              ],
        ),
        ],
      ),
      
    );
  }
}
