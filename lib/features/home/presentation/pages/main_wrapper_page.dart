import 'package:flutter/material.dart';
import '../../../../config/app_router.dart';
import '../../../explore/presentation/pages/explore_page.dart';
import '../../../social/presentation/pages/activity_page.dart';
import 'home_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../auth/presentation/pages/get_started_page.dart'; // Primary Color
import 'package:flutter/cupertino.dart'; // For a few icons

class MainWrapperPage extends StatefulWidget {
  const MainWrapperPage({super.key});

  @override
  State<MainWrapperPage> createState() => _MainWrapperPageState();
}

class _MainWrapperPageState extends State<MainWrapperPage> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // List of pages to keep alive in PageView
  final List<Widget> _pages = [
    const HomePage(),
    const ExplorePage(),
    const ActivityPage(),
    const ProfilePage(
      userId: 'kippy_fan_123',
    ), // Mock passing user id to distinguish from general 'Settings' usage
  ];

  void _onNavigationTapped(int index) {
    if (index == 2) {
      // Create Button tapped (middle button usually) - Push as a full screen or bottom sheet
      Navigator.pushNamed(context, AppRoutes.create);
      return;
    }

    // Adjust index because we have 5 items in the bottom nav but only 4 pages in the stack
    int stackIndex = index;
    if (index > 2) {
      stackIndex = index - 1;
    }

    _pageController.animateToPage(
      stackIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _getBottomNavIndex() {
    if (_currentIndex >= 2) {
      return _currentIndex + 1;
    }
    return _currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getBottomNavIndex(),
        onTap: _onNavigationTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        selectedItemColor: GetStartedConstants.primaryColor,
        unselectedItemColor:
            theme.iconTheme.color?.withAlpha(128) ?? Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 10,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: GetStartedConstants.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
            label: 'Create',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.heart),
            activeIcon: Icon(CupertinoIcons.heart_solid),
            label: 'Activity',
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_solid),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
