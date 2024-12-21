import 'package:flutter/material.dart';
import 'package:bus_tracker_user_app/screens/route_details.dart'; // Import the RouteDetails screen
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  // Function to show the team member's details in a dialog
  void _showTeamMemberDetails(BuildContext context, String name,
      String imageUrl, String bio, String fb, String ln, String ig) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(imageUrl),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(bio),
            const SizedBox(height: 15),
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
    final Uri url = Uri.parse('https://forms.gle/gpLc6EWtai6L3zMT8');
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large Caption with Icon
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) => const RouteDetails()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 16.0),
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 50.0, bottom: 50.0),
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
                                'Click to view routes',
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.green[700]),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.directions_bus,
                            size: 60.0,
                            color: Colors.green[900],
                          ),
                        ],
                      ),
                    ),
                  ),
                  //const SizedBox(height: 40.0),

                  // Feedback Section
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      //color: Colors.green[100],
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
                            'Have suggestions for us?',
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
                            'We value your input to improve the app. Tell us what you think!',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Center(
                          child: ElevatedButton(
                            onPressed:
                                _launchURL, // Directly open the feedback form
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: const Text(
                              'Give Feedback',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
                                      'https://www.linkedin.com/in/samiul-hossen/',
                                      'https://www.instagram.com/samiul.hossen/',
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
                  //const SizedBox(height: 40.0),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const RouteDetails()),
              );
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus),
            label: 'Routes',
          ),
        ],
        selectedItemColor: Colors.green[900],
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}
 
 /*The Home screen is the main screen of the app. It contains the following sections: 
 Find your route! : A large caption with an icon that prompts the user to view the available routes. Feedback Section : A section that allows users to provide feedback about the app. Meet the Team Section : A section that introduces the app development team. 
 The Home screen also includes a bottom navigation bar that allows users to navigate between the Home and Routes screens. 
 The  _showTeamMemberDetails  function is used to display a dialog with the team member’s details when the user taps on a team member’s avatar. The  _launchURL  function is used to open the feedback form URL in a web browser. 
 Step 6: Run the App 
 Now that you have implemented the Home screen, you can run the app to see the changes. 
 To run the app, execute the following command in the terminal: 
 flutter run
 
 The app will launch in the simulator or on a connected device. You should see the Home screen with the sections you implemented. 
 Conclusion 
 In this tutorial, you learned how to create a Home screen for a bus tracking app using Flutter. You implemented the Home screen UI, including sections for finding routes, providing feedback, and meeting the app development team. You also added navigation to the Routes screen and implemented functions to show team member details and open a feedback form URL. 
 To learn more about Flutter, check out our  How to Build a Flutter App series. 
 Join our DigitalOcean community of over a million developers for free! Get help and share knowledge in our Questions & Answers section, find tutorials and tools that will help you grow as a developer and scale your project or business, and subscribe to topics of interest. 
 Flutter is an open-source UI software development kit created by Google. It is used to develop applications for Android, iOS, Linux, Mac, Windows, Google Fuchsia, and the web from a single codebase. 
 In Flutter, a screen is a widget that occupies the entire screen space and is used to display content to the user. Screens are typically implemented as stateful or stateless widgets. 
 A bottom navigation bar is a user interface element that allows users to navigate between different sections of an app. It is typically placed at the bottom of the screen and contains icons or text labels for each section. 
 A dialog is a user interface element that displays information or prompts the user for input. It typically appears as a small window that overlays the main content of the screen.*/
