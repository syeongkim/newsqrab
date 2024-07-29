import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Community',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(), // 로그인 화면을 첫 화면으로 설정
      routes: {
        '/home': (context) => Home(), // 메인 화면을 위한 라우트 설정
      },
    );
  }
}
