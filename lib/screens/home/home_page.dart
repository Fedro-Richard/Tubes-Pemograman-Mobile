import 'package:flutter/material.dart';

import '../../screens/home/home_content.dart';
import '../../screens/riwayat/riwayat_page.dart';
import '../../screens/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContent(),
    RiwayatPage(),
    ProfilePage(),
  ];
s
  @override
  Widget build(BuildContext context) {
    int displayIndex = _selectedIndex;
    if (displayIndex >= _pages.length) {
      displayIndex = _pages.length - 1;
    }
    return Scaffold(
      body: _pages[displayIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: displayIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
