import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // 로그인 함수
  void _login() async {
    if (_usernameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      // API 엔드포인트
      final String apiUrl = 'http://175.106.98.197:3000/users/login';

      // 로그인 데이터
      final Map<String, dynamic> loginData = {
        'username': _usernameController.text,
        'password': _passwordController.text,
      };

      try {
        // POST 요청
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(loginData),
        );

        if (response.statusCode == 200) {
          // 로그인 성공
          final responseData = jsonDecode(response.body);
          print('Login successful with username: ${_usernameController.text}');

          // UserProvider에 사용자 정보 저장
          Provider.of<UserProvider>(context, listen: false).setUser(
            responseData['_id'],
            responseData['username'],
            responseData['nickname'],
          );

          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // 로그인 실패
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('로그인 실패'),
                content: const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                actions: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                    mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                        },
                        child: const Text('확인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                          Navigator.pushNamed(context, '/signup'); // 회원가입 페이지로 이동합니다.
                        },
                        child: const Text('회원가입'),
                      ),
                    ],
                  ),
                ],
                actionsAlignment: MainAxisAlignment.center, // 액션들을 가운데 정렬
              );
            },
          );
        }
      } catch (e) {
        // 네트워크 오류 처리
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('네트워크 오류'),
              content: Text('로그인 중 오류가 발생했습니다: $e'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                  },
                  child: const Text('확인'),
                ),
              ],
            );
          },
        );
      }
    }
  }

  void _naverLogin() async {
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      final NaverAccountResult account = await FlutterNaverLogin.currentAccount();

      print('로그인 성공: $account'); // 사용자 이메일 정보 출력
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
                title: const Text('로그인 실패'),
                content: const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                actions: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                    mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                        },
                        child: const Text('확인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                          Navigator.pushNamed(context, '/signupNaver'); // 회원가입 페이지로 이동합니다.
                        },
                        child: const Text('회원가입'),
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
      appBar: AppBar(
        backgroundColor: Colors.white, //배경색 흰색
        title: Row(
          children: [
            Image.asset('assets/images/newsQrab.jpg', height: 40),
            SizedBox(width: 10),
            Image.asset('assets/images/newsqrab_l.jpg', height: 40),
            SizedBox(width: 10),
            Text('로그인'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // body의 배경색을 흰색으로 설정
        child: Center(
          child: SingleChildScrollView( // overflow 해결_Expanded 보다 SingleChildScrollView 선호
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // 회색 배경색
                  borderRadius: BorderRadius.circular(30), // 둥근 정도
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text('로그인'),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _naverLogin,
                      child: Image.asset('assets/images/naverlogin.png', height: 50),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


/*import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // 로그인 로직 구현 (API 호출 등)
    // 로그인 성공 시 메인 화면으로 이동
    if (_usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (_usernameController.text == "test" &&
          _passwordController.text == "1234") {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('로그인 실패'),
              content: const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
              actions: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                  mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                      },
                      child: const Text('확인'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                        Navigator.pushNamed(
                            context, '/signup'); // 회원가입 페이지로 이동합니다.
                      },
                      child: const Text('회원가입'),
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

      print('로그인 성공: $account'); // 사용자 이메일 정보 출력
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
                title: const Text('로그인 실패'),
                content: const Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
                actions: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min, // 컬럼의 크기를 내용물 크기에 맞춤
                    mainAxisAlignment: MainAxisAlignment.center, // 아이템들을 센터 정렬
                    children: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 현재 대화 상자를 닫습니다.
                        },
                        child: const Text('확인'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // 로그인 실패 대화 상자를 닫습니다.
                          Navigator.pushNamed(
                              context, '/signupNaver'); // 회원가입 페이지로 이동합니다.
                        },
                        child: const Text('회원가입'),
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
      appBar: AppBar(
        backgroundColor: Colors.white, //배경색 흰색
        title: Row(
          children: [
            Image.asset('assets/images/newsQrab.jpg',height: 40),
            SizedBox(width: 10),
            Image.asset('assets/images/newsqrab_l.jpg',height: 40),
            SizedBox(width: 10),
            Text('로그인'),
              ],
            ),
        ),
      body: Container(
        color: Colors.white, // body의 배경색을 흰색으로 설정
        child: Center(
          child: SingleChildScrollView( // overflow 해결_Expanded 보다 SingleChildScrollView 선호
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // 회색 배경색
                  borderRadius: BorderRadius.circular(30), // 둥근 정도
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _login,
                        child: Text('로그인'),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: _naverLogin,
                      child: Image.asset('assets/images/naverlogin.png',height:50),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} */
