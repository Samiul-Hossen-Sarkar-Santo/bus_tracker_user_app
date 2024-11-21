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
            'Bus Tracker',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green[900],
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: widget.routeModel.image.isNotEmpty
                ? Image.asset(
                    "assets/images/${widget.routeModel.image}", // Adjust the path to your folder
                    errorBuilder: (context, error, stackTrace) {
                      debugPrint(
                          "Error loading image: ${widget.routeModel.image}");
                      return const Center(
                        child: Text("Image not available"),
                      );
                    },
                  )
                : const Center(
                    child: Text("No image provided"),
                  ),
          ),
        ));
  }
}
