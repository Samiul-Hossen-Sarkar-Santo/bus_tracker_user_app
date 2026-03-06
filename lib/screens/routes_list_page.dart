import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:bus_tracker_user_app/screens/map_page.dart';
import 'package:bus_tracker_user_app/theme/app_theme.dart';
import 'package:flutter/material.dart';

class RoutesListPage extends StatefulWidget {
  const RoutesListPage({super.key});

  @override
  State<RoutesListPage> createState() => _RoutesListPageState();
}

class _RoutesListPageState extends State<RoutesListPage> {
  // Variable to store search query
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Filtered list of routes based on the search query
    final filteredRoutes = RouteModel.values.where((route) {
      return searchQuery.isEmpty ||
          route.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          route.stopsInOrder.any(
              (stop) => stop.toLowerCase().contains(searchQuery.toLowerCase()));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
        centerTitle: true,
        backgroundColor:
            isDark ? AppTheme.primaryGreen : theme.colorScheme.primary,
        foregroundColor: isDark ? Colors.white : theme.colorScheme.onPrimary,
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
                prefixIcon:
                    Icon(Icons.search, color: theme.colorScheme.primary),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon:
                            Icon(Icons.clear, color: theme.colorScheme.primary),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                filled: true,
                fillColor: isDark ? theme.colorScheme.surface : Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 3 / 2,
                ),
                itemCount: filteredRoutes.length,
                itemBuilder: (context, index) {
                  final route = filteredRoutes[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) => MapPage(title: route.title),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 7,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      color: isDark
                          ? const Color(0xFF388E3C).withValues(alpha: 0.7)
                          : Colors.green[50],
                      child: Center(
                        child: Text(
                          route.title,
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 17.0,
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
    );
  }
}
