import 'package:flutter/material.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followerList;

  FollowerPage({required this.followerList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팔로워 목록'),
      ),
      body: followerList.isNotEmpty
          ? ListView.builder(
        itemCount: followerList.length,
        itemBuilder: (context, index) {
          final user = followerList[index];
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
                    print('프로필 자세히 보기: $user');
                  },
                  child: Text('프로필 자세히'),
                ),
                SizedBox(width: 10), // 버튼 간의 간격 조정
                ElevatedButton(
                  onPressed: () {
                    // 여기에 언팔로우 기능 추가
                    print('언팔로우 클릭: $user');
                  },
                  child: Text('언팔로우'),
                ),
              ],
            ),
          );
        },
      )
          : Center(
        child: Text('아직 팔로우가 없어요!'),
      ),
    );
  }
}
