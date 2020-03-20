import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

List<CameraDescription> cameras;

// StatefulWidgetで管理されるStateオブジェクト
// ignore: must_be_immutable
class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();

  CameraScreen(List<CameraDescription> _cameras) {
    cameras = _cameras;
  }
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController controller;
  String imagePath;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // カメラ初期設定
    controller = CameraController(
      cameras[0], //背面カメラのみ
      ResolutionPreset.medium,
      enableAudio: false, //音声は不要
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldKey,
        body: Column(
          children: <Widget>[
            Expanded(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () => onTakePictureButtonPressed(),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// カメラボタン押下
  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      setState(() {
        imagePath = filePath;
      });
      if (filePath != null) showInSnackBar('Picture saved to $filePath');
    });
  }

  /// スナックバー表示、画像保存時にファイルパスが表示される
  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  /// タイムスタンプ取得
  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// カメラ撮影処理
  Future<String> takePicture() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String dirPath = '${directory.path}/Pictures/flutter';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    try {
      controller.takePicture(filePath); // 撮影
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    return filePath;
  }

  /// カメラエラー
  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
  }

  /// エラーログ
  void logError(String code, String message) =>
      print('Error: $code/nError Message: $message');
}
