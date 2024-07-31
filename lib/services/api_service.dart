// api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final String baseUrl = 'http://175.106.98.197:3000'; // 여기에 실제 API의 베이스 URL을 넣으세요

  // 사용자 프로필 업데이트
  static Future<void> updateUserProfile(String userId, Map<String, String> data) async {
    print('!!!!!!!!!!!!!!!!프로필수정함수 호출됨');
    final String url = '$baseUrl/users/$userId/profile';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }
}
