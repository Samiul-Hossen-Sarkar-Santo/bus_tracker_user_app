import 'package:flutter/material.dart';
import 'package:bus_tracker_user_app/models/route_model.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // List of all routes
  final List<RouteModel> allRoutes = RouteModel.values;

  // List of filtered routes based on search query
  List<RouteModel> filteredRoutes = [];

  // Controller for the search input
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially show all routes
    filteredRoutes = allRoutes;
  }

  // Function to filter routes based on stoppage name
  void filterRoutes(String query) {
    final lowercasedQuery = query.toLowerCase();

    setState(() {
      filteredRoutes = allRoutes.where((route) {
        // Check if any stoppage in the route matches the query
        return route.stops_in_order.any((stop) {
              return stop.toLowerCase().contains(lowercasedQuery);
            }) ||
            route.title
                .toLowerCase()
                .contains(lowercasedQuery); // Match title too
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Bus Routes'),
        backgroundColor: Colors.green[900],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: searchController,
              onChanged: (query) => filterRoutes(query),
              decoration: const InputDecoration(
                labelText: 'Search Stoppage',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 20),
            // Display filtered routes
            Expanded(
              child: ListView.builder(
                itemCount: filteredRoutes.length,
                itemBuilder: (context, index) {
                  final route = filteredRoutes[index];

                  return ListTile(
                    title: Text(route.title),
                    subtitle: Text(
                        'Starts at: ${route.start} - Ends at: ${route.end}'),
                    onTap: () {
                      // You can add a navigation to route details if needed
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
