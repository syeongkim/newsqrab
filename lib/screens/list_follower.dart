import 'package:flutter/material.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followerList;

  FollowerPage({required this.followerList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('팔로워 목록', style: TextStyle(fontSize: 18)), // AppBar 텍스트 크기 조정
      ),
      body: followerList.isNotEmpty
          ? ListView.separated(
        itemCount: followerList.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey.shade300, // 디바이더 색상 설정
        ),
        itemBuilder: (context, index) {
          final user = followerList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/images/crabi.png'), // 기본 프로필 사진
            ),
            title: Text(
              user,
              style: TextStyle(fontSize: 16), // 제목 폰트 크기 조정
            ),
            subtitle: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 여기에 프로필 자세히 보기 기능 추가
                    print('프로필 자세히 보기: $user');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE65C5C), // 버튼 배경색 회색
                    minimumSize: Size(100, 36), // 버튼 크기 조정
                  ),
                  child: Text(
                    '프로필 자세히',
                    style: TextStyle(
                      color: Colors.white, // 버튼 텍스트 색상 흰색
                      fontSize: 12, // 버튼 텍스트 폰트 크기 조정
                    ),
                  ),
                ),
                SizedBox(width: 10), // 버튼 간의 간격 조정
                ElevatedButton(
                  onPressed: () {
                    // 여기에 언팔로우 기능 추가
                    print('언팔로우 클릭: $user');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB0B0B0), // 버튼 배경색 회색
                    minimumSize: Size(100, 36), // 버튼 크기 조정
                  ),
                  child: Text(
                    '언팔로우',
                    style: TextStyle(
                      color: Colors.white, // 버튼 텍스트 색상 흰색
                      fontSize: 12, // 버튼 텍스트 폰트 크기 조정
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )
          : Center(
        child: Text('아직 팔로우가 없어요!', style: TextStyle(fontSize: 16)), // 메시지 텍스트 크기 조정
      ),
    );
  }
}
