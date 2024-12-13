import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:bus_tracker_user_app/screens/map_page.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
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
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: widget.routeModel.image.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Text(
                          'Route Image',
                          style: TextStyle(
                            color: Colors.green[900],
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                        ),
                        Expanded(
                          child: InteractiveViewer(
                            panEnabled: true, // Enable panning
                            minScale: 0.75, // Minimum zoom scale
                            maxScale: 5.0, // Maximum zoom scale
                            child: Image.asset(
                              "assets/images/${widget.routeModel.image}",
                              errorBuilder: (context, error, stackTrace) {
                                debugPrint(
                                    "Error loading image: ${widget.routeModel.image}");
                                return const Center(
                                  child: Text("Image not available"),
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
                              busId: widget
                                  .routeModel.busId, // Pass the specific busId
                            ),
                          ),
                        );
                        print("tapped on view on map button");
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
