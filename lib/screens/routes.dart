import 'package:bus_tracker_user_app/models/route_model.dart';
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
          color: Colors.white, // Set back button color to white
        ),
      ),
      body: widget.routeModel.image.isNotEmpty
          ? Center(
              child: InteractiveViewer(
                onInteractionUpdate: (ScaleUpdateDetails details) {
                  debugPrint("Scale: ${details.scale}");
                },
                panEnabled: true, // Enable panning
                minScale: 1.0, // Minimum zoom scale
                maxScale: 5.0, // Maximum zoom scale
                child: Align(
                  alignment: Alignment.center, // Center the image
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
                        .contain, // Adjust the image to fit within the screen
                  ),
                ),
              ),
            )
          : const Center(
              child: Text("No image provided"),
            ),
    );
  }
}
