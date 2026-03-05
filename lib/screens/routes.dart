import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:bus_tracker_user_app/screens/map_page.dart';
import 'package:flutter/material.dart';

class Routes extends StatefulWidget {
  const Routes({
    super.key,
    required this.routeModel,
  });

  final RouteModel routeModel;

  @override
  State<Routes> createState() => _RoutesState();
}

class _RoutesState extends State<Routes> {
  static const String _fallbackImageAsset =
      "assets/images/BUP_BUS_TRACKER_LOGO.png";
  static const Set<String> _availableRouteImages = {
    "BUS_ROUTE_STD-0.png",
    "BUS_ROUTE_STD-1.png",
    "BUS_ROUTE_STD-2.png",
    "BUS_ROUTE_STD-3.png",
    "BUS_ROUTE_STD-4.png",
    "BUS_ROUTE_STD-5.png",
    "BUS_ROUTE_STD-6.png",
  };

  String _resolveRouteImageAsset(String imageName) {
    if (_availableRouteImages.contains(imageName)) {
      return "assets/images/$imageName";
    }
    return _fallbackImageAsset;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Route Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
      ),
      body: Column(
        children: [
          // Route Image Section
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.3)
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                        : Colors.grey.withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: widget.routeModel.image.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: InteractiveViewer(
                            panEnabled: true, // Enable panning
                            minScale: 0.75, // Minimum zoom scale
                            maxScale: 5.0, // Maximum zoom scale
                            child: Image.asset(
                              _resolveRouteImageAsset(widget.routeModel.image),
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                    "Error loading image: ${widget.routeModel.image}");
                                return Image.asset(
                                  _fallbackImageAsset,
                                  fit: BoxFit.fitWidth,
                                  errorBuilder: (context, _, __) =>
                                      const Center(
                                    child: Text("Image not available"),
                                  ),
                                );
                              },
                              fit: BoxFit
                                  .fitWidth, // Adjust the image to fill the space
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "Image not found!!!",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
            ),
          ),

          // Action Buttons Section
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // View on Map Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapPage(
                              title: widget.routeModel
                                  .title, // Pass the specific bus title
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: Icon(Icons.map, color: Colors.yellow[500]),
                      label: Text(
                        'View on Map',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.yellow[500],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
