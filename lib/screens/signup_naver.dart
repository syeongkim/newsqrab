import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignupNaver extends StatefulWidget {
  const SignupNaver({super.key});

  @override
  _SignupNaverState createState() => _SignupNaverState();
}

class _SignupNaverState extends State<SignupNaver> {
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
    if (_nicknameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Please fill nickname correctly.'),
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
    }
    // 회원가입 로직 구현 (API 호출 등)
    print('Signing up with ID: ${_nicknameController.text}');
    Navigator.pushNamed(context, '/home');
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
