import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:bus_tracker_user_app/models/route_model.dart';

class MapPage extends StatefulWidget {
  final String busId;

  const MapPage({
    super.key,
    required this.busId,
  });

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
  MapsRoutes routes = MapsRoutes();

  late List<LatLng> points;

  late LatLng _startPoint;
  late LatLng _endPoint;

  late Location _location;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    _initializeRouteCoordinates();
    _listenToBusLocation(); // Start listening for updates when the widget initializes
    _getUserLocation(); // Fetch user's current location
  }

  // Initialize the start and end points based on the bus route
  void _initializeRouteCoordinates() async {
    final route =
        RouteModel.values.firstWhere((route) => route.busId == widget.busId);

    // Set start and end points based on the route
    _startPoint = const LatLng(23.8394494908037, 90.35822879566943); // BUP

    // Set the end point coordinates dynamically based on the route
    switch (route.end) {
      case 'House Building':
        _endPoint = const LatLng(23.87465207023296, 90.40045914907554);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'Kakrail':
        _endPoint = const LatLng(23.737308754695302, 90.4041336775186);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'Maghbazar':
        _endPoint = const LatLng(23.748872039981663, 90.4036745273261);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'Shahbagh':
        _endPoint = const LatLng(23.738106930210062, 90.39587882926317);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'Khamar Bari Mor':
        _endPoint = const LatLng(23.758880509925685, 90.38369216231428);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'Asad Gate':
        _endPoint = const LatLng(23.76011652262059, 90.37288520405924);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      case 'City College':
        _endPoint = const LatLng(23.739079042145477, 90.38338455092443);
        points = route.routeCoordinatesInOrder;
        try {
          await routes.drawRoute(points, route.title, Colors.blue[400]!,
              "AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ");
          setState(() {});
        } catch (e) {
          print("Error drawing route: $e");
        }

        break;
      default:
        _endPoint = _startPoint; // Default to start point if no match
    }
  }

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
        iconTheme: const IconThemeData(
          color: Colors.white, // Back button color
        ),
      ),
      body: _currentLocation != null && _userLocation != null
          ? GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _currentLocation!['lat'],
                  _currentLocation!['long'],
                ),
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: routes.routes,
              markers: {
                // Marker for the bus's current location
                Marker(
                  markerId: const MarkerId('bus_marker'),
                  position: LatLng(
                    _currentLocation!['lat'],
                    _currentLocation!['long'],
                  ),
                  infoWindow: InfoWindow(title: "Bus ${widget.busId}"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow),
                ),
                // Marker for the start point (BUP)
                Marker(
                  markerId: const MarkerId('start_marker'),
                  position: _startPoint,
                  infoWindow: const InfoWindow(title: "BUP"),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueAzure),
                ),
                // Marker for the end point
                Marker(
                  markerId: const MarkerId('end_marker'),
                  position: _endPoint,
                  infoWindow: InfoWindow(
                      title: RouteModel.values
                          .firstWhere((route) => route.busId == widget.busId)
                          .end),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                ),
              },
              onMapCreated: (controller) {
                _mapController = controller;
                _zoomToFit(); // Adjust camera to show both start and end points
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: LinearProgressIndicator(
                  color: Colors.green[900],
                  minHeight: 5.0,
                  semanticsLabel: 'Loading progress',
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
    );
  }

  // Adjust the camera to fit both the start and end points
  void _zoomToFit() {
    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        _startPoint.latitude < _endPoint.latitude
            ? _startPoint.latitude
            : _endPoint.latitude,
        _startPoint.longitude < _endPoint.longitude
            ? _startPoint.longitude
            : _endPoint.longitude,
      ),
      northeast: LatLng(
        _startPoint.latitude > _endPoint.latitude
            ? _startPoint.latitude
            : _endPoint.latitude,
        _startPoint.longitude > _endPoint.longitude
            ? _startPoint.longitude
            : _endPoint.longitude,
      ),
    );

    // Animate the camera to fit the bounds with a padding of 50 units
    _mapController.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50),
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

  Future<void> _getUserLocation() async {
    _location = Location();
    //_userLocation = await _location.getLocation();
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) return;
      }

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });

      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _userLocation!,
            zoom: 14.0,
          ),
        ),
      );
    } catch (e) {
      print("Error retrieving location: $e");
    }
  }
}
