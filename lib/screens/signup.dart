import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // 회원가입 함수
  void _signup() async {
    if (_idController.text.isEmpty ||
        _passwordController.text != _confirmPasswordController.text ||
        _nicknameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill all fields and confirm the password correctly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    } else {
      // API 엔드포인트
      final String apiUrl = 'http://175.106.98.197:3000/users/register';

      // 회원가입 데이터
      final Map<String, dynamic> signupData = {
        'username': _idController.text,
        'password': _passwordController.text,
        'nickname': _nicknameController.text,
        'bio': _bioController.text,
        'profilePicture': _profileImage != null ? base64Encode(_profileImage!.readAsBytesSync()) : null,
      };

      try {
        // POST 요청
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(signupData),
        );

        if (response.statusCode == 201) {
          // 회원가입 성공
          print('Signup successful with ID: ${_idController.text}');
          Navigator.pushNamed(context, '/home');
        } else {
          // 회원가입 실패
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Signup failed: ${response.body}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        // 네트워크 오류 처리
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Network error: $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색 흰색
        title: Row(
          children: [
            Image.asset('assets/images/newsQrab.jpg', height: 40),
            SizedBox(width: 10),
            Image.asset('assets/images/newsqrab_l.jpg', height: 40),
            SizedBox(width: 10),
            Text('회원가입'),
          ],
        ),
      ),
      body: Container(
        color: Colors.white, // Ensure the background color is white
        child: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      controller: _idController,
                      decoration: InputDecoration(labelText: '아이디'),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: '비밀번호'),
                    ),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(labelText: '비밀번호 확인'),
                    ),
                    TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(labelText: '닉네임'),
                    ),
                    if (_profileImage != null)
                      Image.file(_profileImage!, width: 100, height: 100),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color for the button
                        foregroundColor: Colors.white, // Text color for the button
                      ),
                      child: Text('프로필 사진 업로드'),
                    ),
                    TextField(
                      controller: _bioController,
                      decoration: InputDecoration(labelText: '자기소개'),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Background color for the button
                        foregroundColor: Colors.white, // Text color for the button
                      ),
                      child: Text('회원가입'),
                    ),
                    SizedBox(height: 50), // Add space to ensure scrolling if needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
