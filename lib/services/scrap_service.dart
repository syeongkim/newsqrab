import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'user_provider.dart';
import 'package:flutter/material.dart';

class ScrapService {
  final String baseUrl = 'http://175.106.98.197:3000/scraps';

  Future<List<dynamic>> fetchScrapsByUserNickname(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String url = '$baseUrl/${userProvider.nickname}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load scraps');
    }
  }
  // 팔로우한 사용자의 스크랩 데이터를 가져오는 메서드 추가
  Future<List<dynamic>> fetchScrapsByFollowing(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String url = '$baseUrl/following/${userProvider.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      print('Fetched data: $data'); // 디버깅 출력 추가
      return data;
      //return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load following scraps');
    }
  }

  
}
