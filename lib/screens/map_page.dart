import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MapPage extends StatefulWidget {
  final String busId; // Pass the busId to fetch data
  final List<LatLng> routePoints; // Pass route coordinates
  final List<LatLng> stoppagePoints; // Pass stoppage points

  const MapPage({
    Key? key,
    required this.busId,
    required this.routePoints,
    required this.stoppagePoints,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;
  Marker? _busMarker;
  Polyline? _routePolyline;

  @override
  void initState() {
    super.initState();
    _setupRealtimeListener(); // Listen for real-time updates
    _setupRoute(); // Draw the route on the map
  }

  // Set up real-time listener for bus location
  void _setupRealtimeListener() {
    final DatabaseReference busRef = FirebaseDatabase.instance
        .ref(
            "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app/")
        .child('Buses')
        .child(widget.busId)
        .child('location');

    busRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        final LatLng newLocation = LatLng(data['lat'], data['long']);
        setState(() {
          _busMarker = Marker(
            markerId: const MarkerId('busLocation'),
            position: newLocation,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          );
        });

        // Move the camera to the new bus location
        _mapController.animateCamera(CameraUpdate.newLatLng(newLocation));
      }
    });
  }

  // Draw the bus route as a polyline
  void _setupRoute() {
    setState(() {
      _routePolyline = Polyline(
        polylineId: const PolylineId('busRoute'),
        points: widget.routePoints,
        color: Colors.blue,
        width: 5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bus Tracker',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
        backgroundColor: Colors.green[900],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.routePoints.first,
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: {
          if (_busMarker != null) _busMarker!,
          ...widget.stoppagePoints.map(
            (point) => Marker(
              markerId: MarkerId(point.toString()),
              position: point,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          ),
        },
        polylines: {
          if (_routePolyline != null) _routePolyline!,
        },
      ),
    );
  }
}
