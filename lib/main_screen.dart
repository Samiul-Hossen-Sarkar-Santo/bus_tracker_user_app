import 'package:bus_tracker_user_app/screens/all_routes.dart';
import 'package:bus_tracker_user_app/screens/home.dart';
import 'package:bus_tracker_user_app/screens/routes_list_page.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_user_app/theme/app_theme.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index); // Navigate to the selected page
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disables swipe gesture
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: const [
          Home(),
          RoutesListPage(),
          AllRoutesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bus_alert),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'All Routes',
          ),
        ],
        selectedItemColor: isDark
            ? const Color.fromARGB(255, 255, 255, 255)
            : AppTheme.primaryGreen,
        unselectedItemColor:
            isDark ? const Color.fromARGB(255, 0, 255, 17) : Colors.grey,
        backgroundColor:
            isDark ? const Color.fromARGB(255, 20, 81, 24) : Colors.white,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
