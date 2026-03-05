import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:bus_tracker_user_app/models/route_model.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class AllRoutesPage extends StatefulWidget {
  const AllRoutesPage({super.key});

  @override
  State<AllRoutesPage> createState() => _AllRoutesPageState();
}

class _AllRoutesPageState extends State<AllRoutesPage> {
  final Map<String, Polyline> _routePolylines = {};
  final Map<String, Marker> _routeMarkers = {};
  final Map<String, List<Marker>> _busMarkers = {};
  GoogleMapController? _mapController;

  BitmapDescriptor busMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor bupMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor endMarker = BitmapDescriptor.defaultMarker;
  final List<StreamSubscription<DatabaseEvent>> _subscriptions = [];

  void _zoomToFit() {
    if (_mapController == null) return;

    final markers = _buildMarkers();
    if (markers.isEmpty) return;

    // Create LatLngBounds to include all markers
    LatLngBounds bounds = _calculateLatLngBounds(markers);

    _mapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 50), // Add padding
    );
  }

  LatLngBounds _calculateLatLngBounds(Set<Marker> markers) {
    final southwest = markers.fold<LatLng>(
      markers.first.position,
      (prev, element) => LatLng(
        element.position.latitude < prev.latitude
            ? element.position.latitude
            : prev.latitude,
        element.position.longitude < prev.longitude
            ? element.position.longitude
            : prev.longitude,
      ),
    );

    final northeast = markers.fold<LatLng>(
      markers.first.position,
      (prev, element) => LatLng(
        element.position.latitude > prev.latitude
            ? element.position.latitude
            : prev.latitude,
        element.position.longitude > prev.longitude
            ? element.position.longitude
            : prev.longitude,
      ),
    );

    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  Future<void> _loadCustomIcons() async {
    try {
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
      endMarker = await BitmapDescriptor.asset(
        const ImageConfiguration(),
        "assets/images/End_marker.png",
        height: 48.0,
        width: 40.0,
      );
    } catch (e, stackTrace) {
      debugPrint("Custom marker load failed, using defaults: $e");
      debugPrintStack(stackTrace: stackTrace);
      endMarker =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta);
    }
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _initializeRoutes() {
    for (final route in RouteModel.values) {
      final routeId = route.title;

      // Add polyline for this route
      _routePolylines[routeId] = Polyline(
        polylineId: PolylineId(routeId),
        points: route.routeCoordinatesInOrder,
        color: Colors.green.shade700,
        width: 3,
      );

      // Add marker at the ending point of the route
      _routeMarkers[routeId] = Marker(
        markerId: MarkerId("${routeId}_end"),
        position: LatLng(route.endLat, route.endLong),
        infoWindow: InfoWindow(title: "${route.title} Endpoint"),
        icon: endMarker,
      );
    }

    setState(() {});
  }

  void _listenToBusLocations() {
    final DatabaseReference database = FirebaseDatabase.instanceFor(
      app: FirebaseDatabase.instance.app,
      databaseURL:
          "https://bus-tracker-bbaa6-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("Buses");

    for (final route in RouteModel.values) {
      final routeId = route.title;

      for (final busId in route.busId) {
        final subscription = database.child(busId).onValue.listen(
          (event) {
            final data = event.snapshot.value as Map<dynamic, dynamic>?;
            if (data != null &&
                data.containsKey('location') &&
                data.containsKey('status') &&
                data['status'] == true) {
              final location = data['location'] as Map<dynamic, dynamic>;
              if (location.containsKey('lat') && location.containsKey('long')) {
                final num? lat = location['lat'] as num?;
                final num? long = location['long'] as num?;
                if (lat == null || long == null) {
                  return;
                }

                final LatLng busPosition =
                    LatLng(lat.toDouble(), long.toDouble());
                final busMarker = Marker(
                  markerId: MarkerId(busId),
                  position: busPosition,
                  infoWindow: InfoWindow(title: "Bus on $routeId route"),
                  icon: this.busMarker,
                );

                if (!mounted) {
                  return;
                }
                setState(() {
                  if (!_busMarkers.containsKey(routeId)) {
                    _busMarkers[routeId] = [];
                  }

                  // Remove old marker for the same bus
                  _busMarkers[routeId]!
                      .removeWhere((marker) => marker.markerId.value == busId);

                  // Add new marker
                  _busMarkers[routeId]!.add(busMarker);
                });
              }
            } else {
              // If status is false or invalid, remove the marker for this bus
              if (!mounted) {
                return;
              }
              setState(() {
                _busMarkers[routeId]
                    ?.removeWhere((marker) => marker.markerId.value == busId);
              });
            }
          },
          onError: (error) {
            debugPrint("Error listening to data for bus $busId: $error");
          },
        );
        _subscriptions.add(subscription);
      }
    }
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    //Add BUP marker
    markers.add(Marker(
      markerId: const MarkerId("BUP"),
      position: const LatLng(23.83944781693273, 90.35820879403578),
      infoWindow: const InfoWindow(title: "BUP"),
      icon: bupMarker,
    ));

    // Add route end markers
    markers.addAll(_routeMarkers.values);

    // Add dynamic bus markers
    for (final busMarkerList in _busMarkers.values) {
      markers.addAll(busMarkerList);
    }

    // Add the tapped location marker if it exists
    if (_selectedLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('selected-location'),
          position: _selectedLocation!,
          infoWindow: const InfoWindow(title: "Selected Location"),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines() {
    return _routePolylines.values.toSet();
  }

  late Location _location;
  LatLng? _userLocation;
  LatLng? _selectedLocation;
  // To control the visibility of the text bubble
  bool _showBubble = true;

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
      if (!mounted ||
          locationData.latitude == null ||
          locationData.longitude == null) {
        return;
      }
      setState(() {
        _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
      });
    } catch (e, stackTrace) {
      debugPrint("Error retrieving location: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _openGoogleMaps(LatLng destination) async {
    if (_userLocation == null) {
      _showTransientMessage('Current location is not available yet.');
      return;
    }

    final String googleMapsUrl =
        "https://www.google.com/maps/dir/?api=1&origin=${_userLocation!.latitude},${_userLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=driving";

    final Uri googleMapsUri = Uri.parse(googleMapsUrl);

    try {
      if (!await canLaunchUrl(googleMapsUri)) {
        _showTransientMessage('Could not open Google Maps on this device.');
        return;
      }
      final bool launched = await launchUrl(
        googleMapsUri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        _showTransientMessage('Could not open Google Maps on this device.');
      }
    } catch (e, stackTrace) {
      debugPrint("Could not open Google Maps: $e");
      debugPrintStack(stackTrace: stackTrace);
      _showTransientMessage('Could not open Google Maps on this device.');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          "Open Google Maps?",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "You're about to leave this app and open Google Maps for directions. Do you want to proceed?",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              _openGoogleMaps(_selectedLocation!); // Open Google Maps
            },
            child: const Text(
              "Proceed",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetDirectionsButton() {
    return ElevatedButton(
      onPressed: () {
        _showConfirmationDialog();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
      child: const Text(
        "Get Directions to This Point",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _clearMarker() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedLocation = null;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
      ),
      child: const Text(
        "Clear Marker",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Extracted method to build the text bubble
  Widget _buildTextBubble() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 9.0,
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                'Tap anywhere on the map \nto get directions!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _initializeRoutes();
    _listenToBusLocations();
    _getUserLocation();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _zoomToFit();
    });
  }

  void _showTransientMessage(String message) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Routes', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[900],
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.zoom_out_map),
            onPressed: _zoomToFit, // Zoom to fit markers
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(23.8103, 90.4125), // Adjust to a central point
              zoom: 14,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            markers: _buildMarkers(),
            polylines: _buildPolylines(),
            onMapCreated: (controller) {
              _mapController = controller;
              _zoomToFit();
            },
            onTap: (LatLng tappedLocation) {
              // Add a marker and save the location
              setState(() {
                _selectedLocation = tappedLocation;
                _showBubble = false;
              });
            },
          ),
          if (_selectedLocation != null)
            Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                    child: _buildGetDirectionsButton(),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                    child: _clearMarker(),
                  ),
                ),
              ],
            ),
          if (_showBubble) _buildTextBubble(),
        ],
      ),
    );
  }
}
