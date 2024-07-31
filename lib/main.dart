import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/signup.dart';
import 'screens/signup_naver.dart';
import 'screens/loadinglogin.dart';
import 'services/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News Community',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoadingLogin(), // 로그인 화면을 첫 화면으로 설정
      routes: {
        '/home': (context) => Home(), // 메인 화면을 위한 라우트 설정
        '/login': (context) => Login(), // 로그인 화면을 위한 라우트 설정
        '/signup': (context) => Signup(), // 회원가입 화면을 위한 라우트 설정
        '/signupNaver': (context) => SignupNaver(), // 회원가입 화면을 위한 라우트 설정
      },
    );
  }
}
