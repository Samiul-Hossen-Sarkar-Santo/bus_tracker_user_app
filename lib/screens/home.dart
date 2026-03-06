import 'dart:async';

import 'package:bus_tracker_user_app/screens/all_routes.dart';
import 'package:bus_tracker_user_app/screens/emergency_page.dart';
import 'package:bus_tracker_user_app/theme/app_theme.dart';
import 'package:firebase_database/firebase_database.dart';
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
  static const String _webAppUrl = 'https://bus-tracker-bbaa6.web.app/';
  int _noticePageIndex = 0;
  int _noticeCount = 0;
  final PageController _noticePageController = PageController();
  Timer? _noticeAutoSlideTimer;

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
    await _launchUri(Uri.parse('https://www.youtube.com/watch?v=7BOIRHh1WPQ'));
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

  @override
  void dispose() {
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
              left: 16.0, right: 16.0, bottom: 16, top: 8),
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
              const SizedBox(height: 4),
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
                      height: 40,
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('BUP Bus Tracker'),
        centerTitle: true,
        backgroundColor:
            isDark ? AppTheme.primaryGreen : theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.white : theme.colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().isDarkMode
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: isDark ? Colors.white : theme.colorScheme.onPrimary,
            ),
            onPressed: () {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                          const SizedBox(height: 10.0),
                          Text(
                            'Click to search for your route',
                            style: TextStyle(
                              fontSize: 15.0,
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
                      'Confused on how to use the app?',
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
                        color: isDark
                            ? Colors.white
                            : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTeamMember(
                          context,
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
                          'Santo',
                          'assets/images/Santo.png',
                          'Lead Developer and Designer',
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
                    _launchUri(Uri.parse(_webAppUrl));
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
                    'Open Web App',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(
    BuildContext context,
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
