import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:bus_tracker_user_app/models/route_model.dart';

class MapPage extends StatefulWidget {
  final String busId;

  const MapPage({super.key, required this.busId});

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
  final Set<Polyline> _polylines = {}; // To hold the polyline(s)
  late LatLng _startPoint;
  late LatLng _endPoint;
  late Location _location;
  LatLng? _userLocation;

  int _selectedRouteIndex = 0;
  final List<List<LatLng>> _allRoutes = [];

  @override
  void initState() {
    super.initState();
    _initializeRouteCoordinates();
    _listenToBusLocation(); // Start listening for updates when the widget initializes
    _getUserLocation(); // Fetch user's current location
    _getRoutes(); // Fetch polyline from the Directions API
  }

  // Initialize the start and end points based on the bus route
  void _initializeRouteCoordinates() {
    final route =
        RouteModel.values.firstWhere((route) => route.busId == widget.busId);

    // Set start and end points based on the route
    _startPoint = const LatLng(23.8394494908037, 90.35822879566943); // BUP

    // Set the end point coordinates dynamically based on the route
    switch (route.end) {
      case 'House Building':
        _endPoint = const LatLng(23.87465207023296, 90.40045914907554);
        break;
      case 'Kakrail':
        _endPoint = const LatLng(23.737308754695302, 90.4041336775186);
        break;
      case 'Maghbazar':
        _endPoint = const LatLng(23.748872039981663, 90.4036745273261);
        break;
      case 'Shahbagh':
        _endPoint = const LatLng(23.738106930210062, 90.39587882926317);
        break;
      case 'Khamar Bari Mor':
        _endPoint = const LatLng(23.758880509925685, 90.38369216231428);
        break;
      case 'Asad Gate':
        _endPoint = const LatLng(23.76011652262059, 90.37288520405924);
        break;
      case 'City College':
        _endPoint = const LatLng(23.739079042145477, 90.38338455092443);
        break;
      default:
        _endPoint = _startPoint; // Default to start point if no match
    }
  }

  // Fetch route polyline using Google Maps Directions API
  Future<void> _getRoutes() async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_startPoint.latitude},${_startPoint.longitude}&destination=${_endPoint.latitude},${_endPoint.longitude}&alternatives=true&key=AIzaSyBPG9_0-rQAXGWv3zfvooLT-M238Rop9wQ';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        final routes = data['routes'];
        for (var route in routes) {
          final points = _decodePolyline(route['overview_polyline']['points']);
          _allRoutes.add(points);
        }
        _highlightRoutes();
      } else {
        print("Error fetching directions: ${data['status']}");
      }
    } else {
      print("Failed to fetch directions. Status code: ${response.statusCode}");
    }
  }

  void _highlightRoutes() {
    setState(() {
      _polylines.clear();
      for (int i = 0; i < _allRoutes.length; i++) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('route_$i'),
            points: _allRoutes[i],
            color: i == _selectedRouteIndex ? Colors.blue : Colors.grey,
            width: i == _selectedRouteIndex ? 6 : 3,
          ),
        );
      }
    });
  }

  void _onRouteTapped(int index) {
    setState(() {
      _selectedRouteIndex = index;
    });
    _highlightRoutes();
  }

  // Decode polyline points from the Directions API
  List<LatLng> _decodePolyline(String encodedPolyline) {
    List<LatLng> polylinePoints = [];
    int index = 0;
    int len = encodedPolyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encodedPolyline.codeUnitAt(index) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        index++;
      } while (byte >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        byte = encodedPolyline.codeUnitAt(index) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
        index++;
      } while (byte >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      polylinePoints.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylinePoints;
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
              polylines: _polylines,
              onTap: (LatLng position) {
                // Check if the tap is on a route and switch selection
                for (int i = 0; i < _allRoutes.length; i++) {
                  if (_allRoutes[i].contains(position)) {
                    _onRouteTapped(i);
                    break;
                  }
                }
              },
              onMapCreated: (controller) {
                _mapController = controller;
                _zoomToFit();
              },
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
