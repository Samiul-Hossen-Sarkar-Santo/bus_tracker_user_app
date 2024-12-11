import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  BitmapDescriptor busMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor bupMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endMarker = BitmapDescriptor.defaultMarker;

  late List<LatLng> points = [];

  String busName = "";

  late LatLng _startPoint;
  late LatLng _endPoint;

  late Location _location;
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    addCustomIcon();
    _initializeRouteCoordinates();
    _listenToBusLocation();
    _getUserLocation();
  }

  void addCustomIcon() {
    BitmapDescriptor.asset(
            const ImageConfiguration(), "assets/images/Bus_marker.png")
        .then((Icon) {
      setState(() {
        busMarker = Icon;
      });
    });
    BitmapDescriptor.asset(
            const ImageConfiguration(), "assets/images/BUP_marker.png")
        .then((Icon) {
      setState(() {
        bupMarker = Icon;
      });
    });
    BitmapDescriptor.asset(
            const ImageConfiguration(), "assets/images/End_marker.png")
        .then((Icon) {
      setState(() {
        endMarker = Icon;
      });
    });
  }

  // Initialize the start and end points based on the bus route
  void _initializeRouteCoordinates() async {
    final route =
        RouteModel.values.firstWhere((route) => route.busId == widget.busId);

    // Set start and end points based on the route
    _startPoint = LatLng(route.startLat, route.startLong); // BUP
    _endPoint = LatLng(route.endLat, route.endLong);
    points = route.routeCoordinatesInOrder;
    print("Endpoint: $_endPoint");
    print("Stoppages: $points");
    busName = route.title;
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
              polylines: {
                Polyline(
                  polylineId: const PolylineId("Route"),
                  points: points,
                  color: Colors.lightBlue,
                  width: 5,
                ),
              },
              markers: {
                // Marker for the bus's current location
                Marker(
                  markerId: const MarkerId('Bus'),
                  position: LatLng(
                    _currentLocation!['lat'],
                    _currentLocation!['long'],
                  ),
                  infoWindow: InfoWindow(title: busName),
                  icon: busMarker,
                ),
                // Marker for the start point (BUP)
                Marker(
                  markerId: const MarkerId('BUP'),
                  position: _startPoint,
                  infoWindow: const InfoWindow(title: "BUP"),
                  icon: bupMarker,
                ),
                // Marker for the end point
                Marker(
                  markerId: const MarkerId('End'),
                  position: _endPoint,
                  infoWindow: InfoWindow(
                      title: RouteModel.values
                          .firstWhere((route) => route.busId == widget.busId)
                          .end),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta),
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
