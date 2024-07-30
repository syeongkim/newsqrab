import 'package:flutter/material.dart';

class LoadingLogin extends StatefulWidget {
  @override
  _LoadingLoginState createState() => _LoadingLoginState();
}

class _LoadingLoginState extends State<LoadingLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 배경색을 설정합니다.
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/newsQrab.jpg',
                          width: 100,
                          height: 100,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'NEWSQRAB',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // 텍스트 색상
                          ),
                        ),
                      ],
                    ),
                  ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          minimumSize: Size(250, 50),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('로그인'),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');// 회원가입처리
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(250, 50),
                          foregroundColor: Colors.white,
                        ),
                        child: Text('회원가입'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}