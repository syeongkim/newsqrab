import 'package:flutter/material.dart';
import 'following.dart';
import 'explore.dart';
import 'scrap.dart';
import 'reels.dart';
import 'myclip.dart';

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('알림'),
          content: const Text('여기에 알림 내용이 표시됩니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('닫기'),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
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
                  IconButton(
                    iconSize: 32.0, // 아이콘 크기를 32으로 설정
                    icon: Icon(Icons.notifications),
                    onPressed: () {
                      _showNotifications(context);
                    },
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
              AssetImage(
                  'assets/images/trendingicon.png'), // Custom icon for home
            ),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/searchicon.png'), // Custom icon for home
            ),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/videoicon.png'), // Custom icon for home
            ),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/images/myicon.png'), // Custom icon for home
            ),
            label: 'My Clip',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        // BottomNavigationBar의 배경색을 흰색으로 설정
        onTap: _onItemTapped,
      ),
    );
  }
}
