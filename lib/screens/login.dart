import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 로그인 로직 구현 (API 호출 등)
    // 로그인 성공 시 메인 화면으로 이동
    Navigator.pushReplacementNamed(context, '/home');
  }

  void _naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      final NaverAccountResult account = await FlutterNaverLogin.currentAccount();

      print('로그인 성공: ${account}'); // 사용자 이메일 정보 출력
      Navigator.pushReplacementNamed(context, '/home'); // 로그인 성공 시 홈 화면으로 이동
    } catch (e) {
      print('네이버 로그인 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('로그인')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: '아이디'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('로그인'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: _naverLogin,
              child: Text('네이버로 로그인'),
            ),
          ],
        ),
      ),
    );
  }
}
