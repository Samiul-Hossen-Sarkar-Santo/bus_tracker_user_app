import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MapPage extends StatefulWidget {
  final String busId;

  const MapPage({
    Key? key,
    required this.busId,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("Buses");

  Map<String, dynamic>? _currentLocation;
  late GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _listenToBusLocation(); // Start listening for updates when the widget initializes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bus Tracker')),
      body: _currentLocation != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!['lat'],
                  _currentLocation!['long'],
                ),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('bus_marker'),
                  position: LatLng(
                    _currentLocation!['lat'],
                    _currentLocation!['long'],
                  ),
                  infoWindow: InfoWindow(title: "Bus ${widget.busId}"),
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
              },
            )
          : const Center(
              child: Text(
                "Something went wrong. \n\nPlease try again later...",
                textAlign: TextAlign.center,
              ),
            ),
    );
  }

  void _listenToBusLocation() {
    _database.child(widget.busId).child('location').onValue.listen(
      (event) {
        print("Data snapshot received: ${event.snapshot.value}");
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null &&
            data.containsKey('lat') &&
            data.containsKey('long')) {
          setState(() {
            _currentLocation = {
              "lat": data['lat'],
              "long": data['long'],
            };
          });
          print("Updated location: $_currentLocation");

          // Automatically move the camera to the new location
          // ignore: unnecessary_null_comparison
          if (_mapController != null) {
            _mapController.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(data['lat'], data['long']),
              ),
            );
          }
        } else {
          print("Invalid or missing location data for bus ID: ${widget.busId}");
          setState(() {
            _currentLocation = null;
          });
        }
      },
      onError: (error) {
        print("Error while listening to location updates: $error");
        setState(() {
          _currentLocation = null;
        });
      },
    );
  }
}
