import 'dart:async';

import 'package:bus_tracker_user_app/screens/all_routes.dart';
import 'package:bus_tracker_user_app/screens/emergency_page.dart';
import 'package:bus_tracker_user_app/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_user_app/screens/routes_list_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:bus_tracker_user_app/providers/theme_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const String _webAppUrl = 'https://bus-tracker-bup.web.app/';
  static const String _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.bus_tracker_user_app.app';
  static const String _playStoreDriverUrl =
      'https://play.google.com/store/apps/details?id=com.bus_tracker_driver_app.app';
  static const String _driverTutorialUrl =
      'https://youtu.be/eDqTXcaPr5Y?si=BYopOJhxeSEZnjQp';
  int _noticePageIndex = 0;
  int _noticeCount = 0;
  final PageController _noticePageController = PageController();
  final ScrollController _homeScrollController = ScrollController();
  Timer? _noticeAutoSlideTimer;
  bool _showScrollHint = false;

  final DatabaseReference _noticeRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        'https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('Notice');

  // Function to show the team member's details in a dialog
  void _showTeamMemberDetails(BuildContext context, String name,
      String imageUrl, String bio, String fb, String ln, String ig, String mh) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                _launchMHURL(mh);
              },
              child: CircleAvatar(
                backgroundImage: AssetImage(imageUrl),
                radius: 50,
              ),
            ),
            const SizedBox(height: 10),
            Text(bio),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.facebook),
                  onPressed: () {
                    _launchFacebookURL(fb);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    _launchLinkedInURL(ln);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.public),
                  onPressed: () {
                    _launchInstaGramURL(ig);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _launchMHURL(mh);
                },
                icon: const Icon(Icons.link),
                label: const Text('Portfolio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL() async {
    await _launchUri(Uri.parse('https://youtu.be/_iEINdj3QfU'));
  }

  Future<void> _launchFacebookURL(String fb) async {
    await _launchUri(Uri.parse(fb));
  }

  Future<void> _launchMHURL(String mh) async {
    await _launchUri(Uri.parse(mh));
  }

  Future<void> _launchLinkedInURL(String ln) async {
    await _launchUri(Uri.parse(ln));
  }

  Future<void> _launchInstaGramURL(String ig) async {
    await _launchUri(Uri.parse(ig));
  }

  Future<void> _launchUri(Uri uri) async {
    try {
      if (await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }

      if (await launchUrl(uri, mode: LaunchMode.platformDefault)) {
        return;
      }

      _showLaunchError();
    } catch (e, stackTrace) {
      debugPrint('Error launching URL: $e');
      debugPrintStack(stackTrace: stackTrace);
      _showLaunchError();
    }
  }

  void _showLaunchError() {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open the requested link.')),
    );
  }

  void _showDisclaimerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Disclaimer'),
        content: const SingleChildScrollView(
          child: Text(
            'BUP Bus Tracker and BUP Bus Tracker- Driver App were developed by students of BUP for the convenience of BUP students, especially daily bus commuters.\n\n'
            'These apps are independent student initiatives and are not official products of Bangladesh University of Professionals (BUP). They are not affiliated with, endorsed by, or operated by BUP, its authorities, departments, administrative offices, faculty, or employees.\n\n'
            'The apps are provided solely to support commuting-related information and convenience for students. Users should verify critical information through official university channels when needed.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.primaryGreen,
              backgroundColor: AppTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _extractNoticeLines(Object? rawNotice) {
    if (rawNotice is String && rawNotice.trim().isNotEmpty) {
      return [rawNotice.trim()];
    }

    if (rawNotice is Map) {
      final noticeEntries = rawNotice.entries
          .where((entry) => entry.value is String)
          .map(
            (entry) => MapEntry(
              entry.key.toString(),
              (entry.value as String).trim(),
            ),
          )
          .where((entry) => entry.value.isNotEmpty)
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key));

      return noticeEntries.map((entry) => entry.value).toList();
    }

    return const [];
  }

  void _syncNoticeAutoSlide(int noticeCount) {
    _noticeCount = noticeCount;

    if (noticeCount <= 1) {
      _noticeAutoSlideTimer?.cancel();
      _noticeAutoSlideTimer = null;

      if (_noticePageIndex != 0 && mounted) {
        setState(() {
          _noticePageIndex = 0;
        });
      }

      if (_noticePageController.hasClients) {
        _noticePageController.jumpToPage(0);
      }
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _noticeAutoSlideTimer != null || _noticeCount <= 1) {
        return;
      }

      _noticeAutoSlideTimer = Timer.periodic(const Duration(seconds: 4), (_) {
        if (!mounted ||
            !_noticePageController.hasClients ||
            _noticeCount <= 1) {
          return;
        }

        final currentPage =
            (_noticePageController.page ?? _noticePageIndex.toDouble()).round();
        final nextPage = (currentPage + 1) % _noticeCount;

        _noticePageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  void _updateScrollHintVisibility() {
    if (!mounted || !_homeScrollController.hasClients) {
      return;
    }

    final position = _homeScrollController.position;
    final shouldShow =
        position.maxScrollExtent > 24 &&
        position.pixels < position.maxScrollExtent - 12;

    if (shouldShow != _showScrollHint) {
      setState(() {
        _showScrollHint = shouldShow;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _homeScrollController.addListener(_updateScrollHintVisibility);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateScrollHintVisibility();
    });
  }

  @override
  void dispose() {
    _homeScrollController
        .removeListener(_updateScrollHintVisibility);
    _homeScrollController.dispose();
    _noticeAutoSlideTimer?.cancel();
    _noticePageController.dispose();
    super.dispose();
  }

  Widget _buildNoticeSection(bool isDark) {
    return StreamBuilder<DatabaseEvent>(
      stream: _noticeRef.onValue,
      builder: (context, snapshot) {
        final notices = snapshot.hasData
            ? _extractNoticeLines(snapshot.data!.snapshot.value)
            : const <String>[];

        _syncNoticeAutoSlide(notices.length);

        final hasNotices = notices.isNotEmpty;
        final currentNoticeIndex =
            _noticePageIndex < notices.length ? _noticePageIndex : 0;
        final noticeTextColor =
            isDark ? Colors.orange[200] : Colors.orange[900];

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16.0),
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 12.0, top: 8.0),
          decoration: BoxDecoration(
            color: isDark ? Colors.transparent : Colors.orange[100],
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: isDark ? Colors.orange[800]! : Colors.orange[700]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.orange[200]!.withValues(alpha: 0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Notice',
                style: TextStyle(
                  fontSize: 13.0,
                  fontWeight: FontWeight.bold,
                  color: noticeTextColor,
                ),
              ),
              //const SizedBox(height: 4.0),
              if (!hasNotices)
                Text(
                  'No notice right now.',
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.orange[900],
                  ),
                  textAlign: TextAlign.center,
                )
              else if (notices.length == 1)
                Text(
                  notices.first,
                  style: TextStyle(
                    fontSize: 11.0,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.orange[900],
                  ),
                  textAlign: TextAlign.center,
                )
              else
                Column(
                  children: [
                    SizedBox(
                      height: 35.0,
                      child: PageView.builder(
                        controller: _noticePageController,
                        itemCount: notices.length,
                        onPageChanged: (index) {
                          if (!mounted) {
                            return;
                          }
                          setState(() {
                            _noticePageIndex = index;
                          });
                        },
                        itemBuilder: (context, index) => Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              notices[index],
                              style: TextStyle(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w500,
                                color:
                                    isDark ? Colors.white : Colors.orange[900],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        notices.length,
                        (index) => Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == currentNoticeIndex
                                ? (isDark ? Colors.white : Colors.black54)
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.35)
                                    : Colors.black26),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      endDrawer: SafeArea(
        top: true,
        bottom: false,
        child: Drawer(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          backgroundColor: isDark
              ? Colors.grey.shade900
              : Colors.grey.shade100,
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppTheme.primaryGreen
                      : theme.colorScheme.primary.withValues(alpha: 0.15),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              SwitchListTile.adaptive(
                title: const Text('Dark Theme'),
                secondary: Icon(
                  themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                ),
                value: themeProvider.isDarkMode,
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                title: const Text('Disclaimer'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showDisclaimerDialog();
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('BUP Bus Tracker'),
        centerTitle: true,
        backgroundColor:
            isDark ? AppTheme.primaryGreen : theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.white : theme.colorScheme.onPrimary,
        actions: [
          Builder(
            builder: (ctx) => IconButton(
              icon: Icon(
                Icons.menu,
                color: isDark ? Colors.white : theme.colorScheme.onPrimary,
              ),
              onPressed: () {
                Scaffold.of(ctx).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _homeScrollController,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              // Notice Section (live from RTDB)
              _buildNoticeSection(isDark),
              const SizedBox(height: 16.0),
              // Find your route
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const RoutesListPage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color.fromARGB(255, 18, 75, 21)
                            .withValues(alpha: 0.3)
                        : theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isDark
                          ? const Color.fromARGB(204, 181, 181, 181)
                          : theme.colorScheme.primary,
                      width: 2.0,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find your route!',
                            style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Click to search for your route',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: isDark
                                  ? AppTheme.darkTextColor
                                  : theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.bus_alert,
                        size: 60.0,
                        color:
                            isDark ? Colors.white : theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  // All Routes viewing
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => const AllRoutesPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color.fromARGB(255, 18, 75, 21)
                                  .withValues(alpha: 0.3)
                              : theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: isDark
                                ? const Color.fromARGB(204, 181, 181, 181)
                                : theme.colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'All Routes!',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                                  ),
                                ),
                                Icon(
                                  Icons.directions_bus,
                                  size: 30.0,
                                  color: isDark
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Click to view all routes in one page',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: isDark
                                    ? AppTheme.darkTextColor
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  // Emergency section
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => const EmergencyPage(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color.fromARGB(255, 18, 75, 21)
                                  .withValues(alpha: 0.3)
                              : theme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: isDark
                                ? const Color.fromARGB(204, 181, 181, 181)
                                : theme.colorScheme.primary,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Emergency!',
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? Colors.white
                                        : theme.colorScheme.primary,
                                  ),
                                ),
                                Icon(
                                  Icons.warning,
                                  size: 30.0,
                                  color: isDark
                                      ? Colors.white
                                      : theme.colorScheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Click to see emergency contacts',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: isDark
                                    ? AppTheme.darkTextColor
                                    : theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              //Driver App Promotion Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 18, 75, 21)
                          .withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(204, 181, 181, 181)
                        : theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : theme.colorScheme.primary,
                          ),
                          children: const [
                            /*TextSpan(
                              text: 'Know how to use\n',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),*/
                            TextSpan(
                              text: 'BUP Bus Tracker- Driver App',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: double.infinity,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                            height: 1.4,
                          ),
                          children: const [
                            TextSpan(
                              text: 'The driver app is available only on the ',
                            ),
                            TextSpan(
                              text: 'Google Play Store',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '. Watch the tutorial video to learn how to use the driver app, or download to try it out!',
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              const targetUrl = _driverTutorialUrl;
                              _launchUri(Uri.parse(targetUrl));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: theme.colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Tutorial Video',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              const targetUrl = _playStoreDriverUrl;
                              _launchUri(Uri.parse(targetUrl));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.secondary,
                              foregroundColor: theme.colorScheme.onSecondary,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 8.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Download',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Tutorial Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 18, 75, 21)
                          .withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(204, 181, 181, 181)
                        : theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Confused on how to use this app?',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Watch this video tutorial to learn how to navigate the app.',
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _launchURL,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.secondary,
                        foregroundColor: theme.colorScheme.onSecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        'Tutorial Video',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Meet the Team Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color.fromARGB(255, 18, 75, 21)
                          .withValues(alpha: 0.3)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: isDark
                        ? const Color.fromARGB(204, 181, 181, 181)
                        : theme.colorScheme.primary,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Meet the Team',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? Colors.white : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTeamMember(
                          context,
                          isDark,
                          'Mohsin',
                          'assets/images/mohsin.png',
                          'Backend Developer and Data Analyst',
                          'https://www.facebook.com/mohsinsrj03',
                          'https://www.instagram.com/vallagena_kichu/',
                          'https://www.linkedin.com/in/mohsinsiraj03/',
                          'https://abd-al-mohsin-siraj.vercel.app',
                        ),
                        _buildTeamMember(
                          context,
                          isDark,
                          'Santo',
                          'assets/images/Santo.png',
                          'Lead Developer and UI/UX Engineer',
                          'https://www.facebook.com/shamiulhossensanto',
                          'https://www.instagram.com/samiul.hossen/',
                          'https://www.linkedin.com/in/samiul-hossen/',
                          'https://samiul-hossen-sarkar-santo.web.app/',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    const targetUrl = kIsWeb ? _playStoreUrl : _webAppUrl;
                    _launchUri(Uri.parse(targetUrl));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    foregroundColor: theme.colorScheme.onSecondary,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  icon: const Icon(Icons.public, color: Colors.white),
                  label: const Text(
                    kIsWeb ? 'Open Play Store' : 'Open Web App',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
                  const SizedBox(height: 56.0),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 9,
            child: IgnorePointer(
              child: AnimatedOpacity(
                opacity: _showScrollHint ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 220),
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.black.withValues(alpha: 0.45)
                          : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 18,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        Text(
                          'Scroll for more',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
    bool isDark,
    String name,
    String imageUrl,
    String bio,
    String fb,
    String ln,
    String ig,
    String mh,
  ) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _showTeamMemberDetails(
                context, name, imageUrl, bio, fb, ln, ig, mh);
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(imageUrl),
            radius: 40,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }
}
