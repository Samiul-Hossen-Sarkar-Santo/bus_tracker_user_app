import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:bus_tracker_user_app/models/route_model.dart';

class MapPage extends StatefulWidget {
  final String title;

  const MapPage({super.key, required this.title});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final DatabaseReference _database = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref("Buses");

  final Map<String, Marker> _busMarkers =
      {}; // Map to hold bus markers dynamically
  GoogleMapController? _mapController;

  BitmapDescriptor busMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor bupMarker = BitmapDescriptor.defaultMarker;

  List<LatLng> points = [];
  String busName = "";

  late LatLng _startPoint;
  late LatLng _endPoint;

  late Location _location;
  // ignore: unused_field
  LatLng? _userLocation;

  final Map<String, List<String>> busesForRoute = {
    "BUP-Uttara": ["busID1", "busID2"],
    "BUP-JFP-Kakrail": ["busID3", "busID4"],
    "BUP-Maghbazar-Kakrail": ["busID5", "busID6"],
    "BUP-Shahbagh": ["busID7", "busID8"],
    "BUP-Khamar Bari Mor": ["busID9", "busID10"],
    "BUP-Asad Gate": ["busID11", "busID12"],
    "BUP-City College": ["busID13", "busID14"],
    "BUP-Jahangir Gate": ["busID15", "busID16"],
  };

  Map<String, String> busStatuses = {}; // Stores the status of each bus

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _initializeRouteCoordinates();
    _listenToBusLocations();
    _getUserLocation();
    _listenToBusStatuses();
  }

  String getBusName(String busId) {
    final route =
        RouteModel.values.firstWhere((route) => route.title == widget.title);
    final List<String> busIds = route.busId;
    if (busIds.first == busId) {
      return "$busName 1";
    } else if (busIds.last == busId) {
      return "$busName 2";
    }
    return "";
  }

  Future<void> _loadCustomIcons() async {
    busMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      "assets/images/Bus_marker.png",
      height: 48.0,
      width: 40.0,
    );
    bupMarker = await BitmapDescriptor.asset(
      const ImageConfiguration(),
      "assets/images/BUP_marker.png",
      height: 48.0,
      width: 40.0,
    );
    setState(() {});
  }

  void _initializeRouteCoordinates() {
    final route =
        RouteModel.values.firstWhere((route) => route.title == widget.title);

    _startPoint = LatLng(route.startLat, route.startLong);
    _endPoint = LatLng(route.endLat, route.endLong);
    points = route.routeCoordinatesInOrder;

    setState(() {
      busName = route.title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Tracker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _startPoint,
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
            markers: _buildMarkers(),
            onMapCreated: (controller) {
              _mapController = controller;
              _zoomToFit();
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBusStatusWidget(),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return {
      ..._busMarkers.values, // Dynamic bus markers
      Marker(
        markerId: const MarkerId('BUP'),
        position: _startPoint,
        infoWindow: const InfoWindow(title: "BUP"),
        icon: bupMarker,
      ),
      Marker(
        markerId: const MarkerId('End'),
        position: _endPoint,
        infoWindow: const InfoWindow(title: "Destination"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ),
    };
  }

  Widget _buildBusStatusWidget() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 55.0, vertical: 30.0),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: busStatuses.entries.map((entry) {
          String status = entry.value;
          return Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Route Name",
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "Bus Status",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getBusName(entry.key), //key e bus id ache
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      color: status == "On Route"
                          ? Colors.green[900]
                          : const Color.fromARGB(255, 182, 18, 6),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    status,
                    style: TextStyle(
                      color: status == "On Route"
                          ? Colors.green[900]
                          : const Color.fromARGB(255, 182, 18, 6),
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _zoomToFit() {
    if (_mapController != null) {
      LatLngBounds bounds = LatLngBounds(
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

      _mapController!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
    }
  }

  void _listenToBusLocations() {
    final route =
        RouteModel.values.firstWhere((route) => route.title == widget.title);
    final List<String> busIds = route.busId;

    for (String busId in busIds) {
      _database.child(busId).child('location').onValue.listen(
        (event) async {
          final data = event.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null &&
              data.containsKey('lat') &&
              data.containsKey('long')) {
            final statusSnapshot =
                await _database.child(busId).child('status').get();
            if (statusSnapshot.value == true) {
              final LatLng busPosition = LatLng(data['lat'], data['long']);

              setState(() {
                _busMarkers[busId] = Marker(
                  markerId: MarkerId(busId),
                  position: busPosition,
                  infoWindow: InfoWindow(title: "Bus: $busName"),
                  icon: busMarker,
                );
              });
            } else {
              setState(() {
                _busMarkers.remove(busId);
              });
            }
          }
        },
        onError: (error) {
          print("Error listening to location for bus $busId: $error");
        },
      );
    }
  }

  void _listenToBusStatuses() {
    final route =
        RouteModel.values.firstWhere((route) => route.title == widget.title);
    final List<String> busIds = route.busId;

    for (String busId in busIds) {
      _database.child(busId).child('status').onValue.listen(
        (event) {
          final data = event.snapshot.value as bool?;
          if (data != null) {
            setState(() {
              busStatuses[busId] = data ? "On Route" : "At BUP";
            });
          }
        },
        onError: (error) {
          print("Error listening to status for bus $busId: $error");
        },
      );
    }
  }

  Future<void> _getUserLocation() async {
    _location = Location();

    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;

      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) return;
      }

      final locationData = await _location.getLocation();
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e) {
      print("Error retrieving location: $e");
    }
  }
}
