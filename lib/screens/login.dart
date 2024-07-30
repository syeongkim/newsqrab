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
    if (!_usernameController.text.isEmpty &&
        !_passwordController.text.isEmpty) {
      if (_usernameController.text == "test" &&
          _passwordController.text == "1234") {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('로그인 실패'),
              content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
              actions: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                  mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                      },
                      child: Text('확인'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                        Navigator.pushNamed(
                            context, '/signup'); // 회원가입 페이지로 이동합니다.
                      },
                      child: Text('회원가입'),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center, // 액션들을 가운데 정렬
            );
          },
        );
      }
    }
  }

  void _naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      final NaverAccountResult account =
          await FlutterNaverLogin.currentAccount();

      print('로그인 성공: ${account}'); // 사용자 이메일 정보 출력
      if (result.status == NaverLoginStatus.loggedIn) {
        if (account.id == "JE3Nx5Ex9e2vRncn5c-JxXzY6hlVjCwM-GGqd6BZq1I") {
          // 네이버 로그인 성공 시
          print("go to home");
          Navigator.pushReplacementNamed(context, '/home'); // 홈 화면으로 이동
        } else {
          print("fail to login");
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('로그인 실패'),
                content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                actions: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                    mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                        },
                        child: Text('확인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                          Navigator.pushNamed(
                              context, '/signupNaver'); // 회원가입 페이지로 이동합니다.
                        },
                        child: Text('회원가입'),
                      ),
                    ],
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center, // 액션들을 가운데 정렬
              );
            },
          );
        }
      }
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
        child: SingleChildScrollView( //overflow 해결_Expanded 보다 SingleChildScrollView 선호
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
      ),
    );
  }
}
