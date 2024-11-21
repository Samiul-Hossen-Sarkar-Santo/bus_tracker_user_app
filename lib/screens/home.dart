import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:bus_tracker_user_app/screens/routes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
<<<<<<< HEAD
      body: Column(
        children: [
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for routes or stops...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
=======
      body: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[100],
        child: Center(
          child: Text(
            'Welcome to the Home Screen!!!',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.green[900],
>>>>>>> a970434d9630fcd104cd13014afa1fd59d176008
            ),
          ),
          // Grid layout for bus routes
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 cards per row
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                  childAspectRatio: 3 / 2, // Aspect ratio for cards
                ),
                itemCount: RouteModel.values.length,
                itemBuilder: (context, index) {
                  final route = RouteModel.values[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => Routes(routeModel: route),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      color: Colors.green[50],
                      child: Center(
                        child: Text(
                          route.title,
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}
