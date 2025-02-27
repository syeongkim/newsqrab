import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../model/user_model.dart';
import 'user_provider.dart';
import 'package:flutter/material.dart';

class ScrapService {
  final String baseUrl = 'http://13.124.11.216:3000/scraps';

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

  // 새로운 함수 추가
  Future<List<dynamic>> fetchScrapsByNickname(String nickname) async {
    final String url = '$baseUrl/$nickname';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load scraps');
    }
  }

  Future<List<dynamic>> fetchScrapsByFollowing(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String url = '$baseUrl/following/${userProvider.userId}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      print('Fetched data: $data'); // 디버깅 출력 추가
      return data;
    } else {
      throw Exception('Failed to load following scraps');
    }
  }

  Future<void> updateFollowerEmoji(String scrapId, String userId, String emoji) async {
    final String url = '$baseUrl/$scrapId/followerEmojis';
    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'userId': userId,
        'emoji': emoji,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update emoji');
    }
  }

  Future<List<dynamic>> fetchTopUsers() async {
    final String url = 'http://13.124.11.216:3000/users/kings';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load top users');
    }
  }

  // 팔로우 상태를 업데이트하는 메서드 추가
  Future<void> updateFollowing(String userId, String followUserId) async {
    final String url = 'http://13.124.11.216:3000/users/$userId/following/$followUserId';

    final response = await http.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update following');
    }
  }

  // 언팔로우 상태를 업데이트하는 메서드 추가
  Future<void> deleteFollowing(String userId, String unfollowUserId) async {
    final String url = 'http://13.124.11.216:3000/users/$userId/following/$unfollowUserId';

    final response = await http.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete following');
    }
  }
  // GET /users/{id} API를 호출하는 메서드 추가
  Future<User> fetchUserById(String userId) async {
    print('^^^^^^^^^^^^^^^^^^^^함수호출시작');
    final String url = 'http://13.124.11.216:3000/users/$userId';
    final response = await http.get(Uri.parse(url));
print('*************get요청보냄');
    if (response.statusCode == 200) {
      print('Response body: ${response.body}');
      try {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        print('Decoded JSON: $userData');
        print('Decoded JSON type: ${userData.runtimeType}');
        return User.fromJson(userData);
      } catch (e) {
        print('Error parsing user data: $e');
        throw Exception('Failed to parse user data');
      }
    } else {
      throw Exception('Failed to load user data');
    }
  }



  // 인기 많은 스크랩 데이터를 가져오는 메서드 추가
  Future<List<dynamic>> fetchHotScraps() async {
    final String url = '$baseUrl/hot';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load hot scraps');
    }
  }
}
