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
        primaryColor: Colors.white, // 기본 primaryColor를 흰색으로 설정
        scaffoldBackgroundColor: Colors.white, // 기본 배경색
        appBarTheme: AppBarTheme(
          color: Colors.white, // AppBar 배경색을 흰색으로 설정
          iconTheme: IconThemeData(color: Colors.black), // AppBar 아이콘 색상
          titleTextStyle: TextStyle(color: Colors.black), // AppBar 제목 텍스트 색상
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // BottomNavigationBar의 배경색을 흰색으로 설정
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          elevation: 4, // 그림자 효과
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black), // 본문 텍스트 색상
          bodyMedium: TextStyle(color: Colors.black54), // 보조 본문 텍스트 색상
        ),
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
