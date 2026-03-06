import 'package:bus_tracker_user_app/screens/all_routes.dart';
import 'package:bus_tracker_user_app/screens/home.dart';
import 'package:bus_tracker_user_app/screens/routes_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
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

  Future<String> getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<void> checkForUpdate() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return;
    }

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (!mounted) {
        return;
      }
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        showUpdateDialog();
      }
    } catch (e, stackTrace) {
      debugPrint('Update check failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void showUpdateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Update Available'),
        backgroundColor: Colors.grey[800],
        content: const Text(
          'A new version of the app is available. Please update to enjoy the latest features.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text(
              'Later',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _performImmediateUpdate();
            },
            child: Text(
              'Update Now',
              style: TextStyle(
                color: Colors.green[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _performImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (e, stackTrace) {
      debugPrint('Immediate update failed: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
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
