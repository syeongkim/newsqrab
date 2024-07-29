import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/signup.dart';
import 'screens/signup_naver.dart';

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
        '/login': (context) => Login(), // 로그인 화면을 위한 라우트 설정
        '/signup': (context) => Signup(), // 회원가입 화면을 위한 라우트 설정
        '/signupNaver': (context) => SignupNaver(), // 회원가입 화면을 위한 라우트 설정
      },
    );
  }
}
