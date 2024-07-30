import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

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

  void _signup() {
    if (_idController.text.isEmpty ||
        _passwordController.text != _confirmPasswordController.text ||
        _nicknameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(
              'Please fill all fields and confirm the password correctly.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    } else {
      // 회원가입 로직 구현 (API 호출 등)
      print('Signing up with ID: ${_idController.text}');
      Navigator.pushNamed(context, '/home');
    }
    // Navigate to home or login page
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

