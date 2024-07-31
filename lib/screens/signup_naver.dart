import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

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

  Future<void> _signup() async {
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
    } else {
      // API 엔드포인트
      final String apiUrl = 'http://175.106.98.197:3000/users/register';

      try {
        // Create Multipart request
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
        request.fields['nickname'] = _nicknameController.text;
        request.fields['bio'] = _bioController.text;

        if (_nicknameController != null) {
          request.fields['usernickname'] = _nicknameController.text;
        }

        if (_profileImage != null) {
          // Adding the image file to the request
          var mimeTypeData = lookupMimeType(_profileImage!.path)?.split('/');
          var file = await http.MultipartFile.fromPath(
            'profilePicture',
            _profileImage!.path,
            contentType: mimeTypeData != null
                ? MediaType(mimeTypeData[0], mimeTypeData[1])
                : null,
          );
          request.files.add(file);
        }

        // Sending the request
        var response = await request.send();

        if (response.statusCode == 201) {
          print('Signup successful');
          Navigator.pushNamed(context, '/home');
        } else {
          print('Signup failed with status: ${response.statusCode}');
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
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
            Image.asset('assets/images/tabbar.png', height: 40),
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
                      decoration: InputDecoration(
                        labelText: '닉네임',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE65C5C)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      cursorColor: Color(0xFFE65C5C),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    if (_profileImage != null)
                      Image.file(_profileImage!, width: 100, height: 100),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // 버튼의 배경색을 회색으로 설정
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2), // 모서리를 각진 사각형으로 설정
                          ),
                        ),
                        child: Text(
                          '프로필 사진 업로드',
                          style: TextStyle(
                            color: Colors.white, // 글씨 색상을 하얀색으로 설정
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _bioController,
                      decoration: InputDecoration(
                        labelText: '자기소개',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFE65C5C)),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      cursorColor: Color(0xFFE65C5C),
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 200,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: _signup,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE65C5C), // 버튼의 배경색을 #E65C5C로 설정
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2), // 모서리를 각진 사각형으로 설정
                          ),
                        ),
                        child: Text(
                          '회원가입',
                          style: TextStyle(
                            color: Colors.white, // 글씨 색상을 하얀색으로 설정
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ), // Add space to ensure scrolling if needed
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
