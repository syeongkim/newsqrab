import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/scrap_service.dart';
import '../../services/user_provider.dart';

class FollowingPage extends StatelessWidget {
  final List<String> followingList;

  FollowingPage({required this.followingList});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.userId ?? ''; // 현재 사용자 ID 가져오기

    return Scaffold(
      appBar: AppBar(
        title: Text('팔로잉 목록'),
      ),
      body: followingList.isNotEmpty
          ? ListView.separated(
        itemCount: followingList.length,
        separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[300]), // 리스트 항목 사이에 디바이더 추가
        itemBuilder: (context, index) {
          final user = followingList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/crabi.png'), // 기본 프로필 사진
            ),
            title: Text(user),
            subtitle: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 여기에 프로필 자세히 보기 기능 추가
                    print('프로필 자세히 보기 클릭: $user');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE65C5C), // 버튼 색상을 회색으로 설정
                    minimumSize: Size(100, 36), // 버튼 크기 조절
                    textStyle: TextStyle(
                      fontSize: 12, // 텍스트 폰트 크기 조절
                    ),
                  ),
                  child: Text(
                    '프로필 자세히',
                    style: TextStyle(color: Colors.white), // 버튼 안의 텍스트 색상을 흰색으로 설정
                  ),
                ),
                SizedBox(width: 10), // 버튼 간의 간격 조정
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await ScrapService().deleteFollowing(userId, user);
                      // 언팔로우 후 리스트에서 해당 사용자 제거
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('언팔로우 성공')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('언팔로우 실패: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // 버튼 색상을 회색으로 설정
                    minimumSize: Size(100, 36), // 버튼 크기 조절
                    textStyle: TextStyle(
                      fontSize: 12, // 텍스트 폰트 크기 조절
                    ),
                  ),
                  child: Text(
                    '언팔로우',
                    style: TextStyle(color: Colors.white), // 버튼 안의 텍스트 색상을 흰색으로 설정
                  ),
                ),
              ],
            ),
          );
        },
      )
          : Center(
        child: Text('아직 팔로잉이 없어요!'),
      ),
    );
  }
}
