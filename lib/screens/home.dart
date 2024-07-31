import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges; // badges 패키지를 별칭으로 임포트
import 'following.dart';
import 'explore.dart';
import 'scrap.dart';
import 'reels.dart';
import 'myclip.dart';

class FollowRequest {
  final String username;

  FollowRequest(this.username);
}

class LikeNotification {
  final String username;

  LikeNotification(this.username);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const Following(), // Following 탭
    const Explore(), // Explore 탭
    const Scrap(), // Scrap 탭
    const Reels(), // Reels 탭
    const Myclip(), // My Clip 탭
  ];

  List<FollowRequest> _followRequests = []; // 팔로우 요청 목록
  List<LikeNotification> _likeNotifications = []; // 좋아요 알림 목록
  int _notificationCount = 0; // 알림 숫자

  @override
  void initState() {
    super.initState();
    // 더미 데이터를 추가
    _followRequests = [
      FollowRequest('user1'),
      FollowRequest('user2'),
      FollowRequest('user3'),
      FollowRequest('user4'),
      FollowRequest('user5'),
    ];
    _likeNotifications = [
      LikeNotification('userA'),
      LikeNotification('userB'),
      LikeNotification('userC'),
    ];
    _notificationCount = _followRequests.length + _likeNotifications.length;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.grey.withOpacity(0.5), // 팝업 배경화면 회색으로 설정
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200], // 팝업 배경색 회색으로 설정
          title: const Text('알림'),
          content: Container(
            width: double.maxFinite,
            height: 400, // 필요한 높이로 설정
            child: ListView.builder(
              itemCount: _followRequests.length + _likeNotifications.length,
              itemBuilder: (context, index) {
                if (index < _followRequests.length) {
                  final request = _followRequests[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 설정
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('새로운 팔로워: ${request.username}.'),
                      ],
                    ),
                  );
                } else {
                  final like = _likeNotifications[index - _followRequests.length];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0), // 둥근 모서리 설정
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('좋아요 알림: ${like.username}.'),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                '닫기',
                style: TextStyle(color: Colors.black), // 텍스트 색상 검정색으로 설정
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white, // AppBar 배경색을 흰색으로 설정
          child: SafeArea(
            child: Container(
              color: Colors.white, // SafeArea 배경색을 흰색으로 설정
              padding: const EdgeInsets.symmetric(horizontal: 16.0), // 좌우 패딩 추가
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, right: 8.0), // 왼쪽 패딩 추가
                        child: Image.asset(
                          'assets/images/newsQrab.jpg',
                          height: kToolbarHeight - 8,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          'assets/images/newsqrab_l.jpg',
                          height: kToolbarHeight - 8,
                        ),
                      ),
                    ],
                  ),
                  badges.Badge(
                    badgeContent: Text(
                      _notificationCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    child: IconButton(
                      iconSize: 32.0, // 아이콘 크기를 32으로 설정
                      icon: const Icon(Icons.notifications),
                      onPressed: () {
                        _showNotifications(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // 전체 화면의 배경색을 흰색으로 설정
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/homeicon.png'), // Custom icon for home
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/trendingicon.png'), // Custom icon for trending
            ),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/searchicon.png'), // Custom icon for search
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/videoicon.png'), // Custom icon for videos
            ),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/myicon.png'), // Custom icon for my clip
            ),
            label: 'My Clip',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
