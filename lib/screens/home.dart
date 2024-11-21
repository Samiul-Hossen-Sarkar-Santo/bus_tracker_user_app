import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:bus_tracker_user_app/screens/routes.dart'; // Import SearchPage
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variable to store search query
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Filtered list of routes based on the search query
    final filteredRoutes = RouteModel.values.where((route) {
      return searchQuery.isEmpty ||
          route.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          route.stops_in_order.any(
              (stop) => stop.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Tracker',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search bar at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for routes or stops...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // Clear search field and reset state
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null, // Show clear button only if searchQuery is not empty
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          // Grid layout for filtered bus routes
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
                itemCount: filteredRoutes.length,
                itemBuilder: (context, index) {
                  final route = filteredRoutes[index];

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
