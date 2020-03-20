import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:cloud_storage_status/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

List<CameraDescription> cameras = [];

// 実行されるmain関数
Future<Null> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {}
  runApp(new MyApp());
}

Color myColorGrey = Color(0xfff2f5f8),
    myColorBlue = Color(0xff3b73de),
    lightText = Color(0xff8891a4);

int activeId = 0;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '名刺管理アプリ',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Raleway'),
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/CameraScreen': (BuildContext context) => new CameraScreen(null),
      },
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: myColorGrey,
        body: Container(
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
                      child: Column(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.menu),
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "flutter + firebase 勉強中",
                            style: TextStyle(
                              color: lightText,
                              fontSize: 25,
                            ),
                          ),
                          Text(
                            "名刺アプリ",
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0),
                    Container(
                      height: 250,
                      child: PageView.builder(
                        itemCount: 2,
                        itemBuilder: (context, id) {
                          return MyContainer(
                            isActive: id == 0 ? true : false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Icon(Icons.add_circle, color: myColorBlue, size: 36,),
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "履歴",
                        style: TextStyle(
                          color: lightText,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 251,
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (ctx, id) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 15),
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Color(0xffecf0f3),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.person),
                            SizedBox(
                              width: 21,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "山田　太郎",
                                          style: TextStyle(
                                              color: Color(0xff333333),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 21),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "株式会社○○○ 090-xxxx-1234 / アポイント場所 : 品川駅",
                                    style: TextStyle(color: lightText),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyContainer extends StatelessWidget {
  final bool isActive;
  const MyContainer({
    Key key,
    this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute<Null>(
              settings: const RouteSettings(name: "/CameraScreen"),
              builder: (BuildContext context) => CameraScreen(cameras),
            ),
          );
        },
      child: Container(
        margin: isActive ? EdgeInsets.only(bottom: 5) : EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(18),
              margin: isActive
                  ? EdgeInsets.only(bottom: 25, top: 25, left: 15, right: 15)
                  : EdgeInsets.only(bottom: 15, top: 25, left: 15, right: 15),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: isActive ? 13.0 : 5.0,
                    offset: Offset(0, isActive ? 13 : 5.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 5.0),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Image.asset('assets/images/business-cards.png', height: 24, width: 24),
                      ),
                      Container(  // 3.1.1行目
                        margin: const EdgeInsets.only(bottom: 4.0),
                      ),
                      Expanded(  // 2.1列目
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(  // 3.1.1行目
                              margin: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                "CTO",
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(  // 3.1.1行目
                              margin: const EdgeInsets.only(bottom: 1.0),
                              child: Text(
                                "名刺　太郎",
                                style: TextStyle(
                                  color: isActive ? Colors.white : Colors.black87,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "株式会社 名刺屋",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "〒100-8111 東京都千代田区千代田1-1",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "TEL 06-xxx-xxx",
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "Email taro@exsample.com",
                        style: TextStyle(
                          color: isActive ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "Twitter @taro_sample",
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
