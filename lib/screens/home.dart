import 'package:bus_tracker_user_app/screens/all_routes.dart';
import 'package:bus_tracker_user_app/screens/emergency_page.dart';
import 'package:flutter/material.dart';
import 'package:bus_tracker_user_app/screens/route_details.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    final Uri url = Uri.parse('https://youtu.be/7BOIRHh1WPQ');
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Future<void> _launchFacebookURL(String fb) async {
    final Uri url = Uri.parse(fb);
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Future<void> _launchMHURL(String mh) async {
    final Uri url = Uri.parse(mh);
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Future<void> _launchLinkedInURL(String ln) async {
    final Uri url = Uri.parse(ln);
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  Future<void> _launchInstaGramURL(String ig) async {
    final Uri url = Uri.parse(ig);
    try {
      await launchUrl(url);
    } catch (e) {
      print('Error launching URL: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        automaticallyImplyLeading: false,
        title: const Text(
          'BUP Bus Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice Section
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 16.0),
                  padding: const EdgeInsets.only(
                      left: 16.0, top: 3.0, bottom: 4.0, right: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.orange[700]!,
                      width: 2.0,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        """Notice""",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[900],
                          shadows: const [
                            Shadow(
                              color: Colors.black12,
                              offset: Offset(1, 1),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        """You can track the live location of the ASAD GATE, JFP-KAKRAIL & CITY COLLEGE route only. And view the detaails of all the routes. We'll include more routes later.""",
                        style: TextStyle(
                          fontSize: 11.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange[900],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              // Find your route
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const RouteDetails()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: Colors.green[700]!,
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
                              color: Colors.green[900],
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            'Click to search for your route',
                            style: TextStyle(
                                fontSize: 15.0, color: Colors.green[700]),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.bus_alert,
                        size: 60.0,
                        color: Colors.green[900],
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 14.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.green[700]!,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'All Routes!',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.028,
                                    ),
                                    Icon(
                                      Icons.directions_bus,
                                      size: constraints.maxWidth * 0.16,
                                      color: Colors.green[900],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxWidth * 0.05,
                                ),
                                Text(
                                  'Click to view all routes in one page',
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth * 0.07,
                                    color: Colors.green[700],
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          );
                        },
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
                          MaterialPageRoute(builder: (ctx) => EmergencyPage()),
                        );
                      },
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 14.5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(
                                color: Colors.green[700]!,
                                width: 2.0,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Emergency!',
                                      style: TextStyle(
                                        fontSize: constraints.maxWidth * 0.115,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[900],
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.028,
                                    ),
                                    Icon(
                                      Icons.warning,
                                      size: constraints.maxWidth * 0.14,
                                      color: Colors.green[900],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxWidth * 0.05,
                                ),
                                Text(
                                  'Click to see emergency contacts',
                                  style: TextStyle(
                                      fontSize: constraints.maxWidth * 0.07,
                                      color: Colors.green[700]),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          );
                        },
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
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.green[700]!,
                    width: 2.0,
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Confused on how to use the app?',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Center(
                      child: Text(
                        'Watch this video tutorial to learn how to navigate the app.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: _launchURL,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text(
                          'Tutorial Video',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Meet the Team Section
              Container(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'Meet the Team',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showTeamMemberDetails(
                                  context,
                                  'Mohsin',
                                  'assets/images/mohsin.png',
                                  'Backend Developer and Data Analyst',
                                  'https://www.facebook.com/mohsinsrj03',
                                  'https://www.instagram.com/vallagena_kichu/',
                                  'https://www.linkedin.com/in/mohsinsiraj03/',
                                  'https://github.com/meawsin',
                                );
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/mohsin.png'),
                                radius: 40,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Mohsin',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _showTeamMemberDetails(
                                  context,
                                  'Santo',
                                  'assets/images/Santo.png',
                                  'Lead Developer and Designer',
                                  'https://www.facebook.com/shamiulhossensanto',
                                  'https://www.instagram.com/samiul.hossen/',
                                  'https://www.linkedin.com/in/samiul-hossen/',
                                  'https://sites.google.com/view/samiul-hossen-sarkar-santo/about-me',
                                );
                              },
                              child: const CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/Santo.png'),
                                radius: 40,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Santo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
