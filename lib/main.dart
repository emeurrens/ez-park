import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EZ Park',
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  static const _latLngUF = LatLng(29.64378349411012, -82.35473240870209);

  int _selectedIndex = 0;
  static LatLng _userPosition = _latLngUF;
  static CameraPosition _kUserPosition = CameraPosition(
    target: _userPosition,
    zoom: 18,
  );


  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }


  static const CameraPosition _kUniversityOfFlorida = CameraPosition(
    target: _latLngUF,
    zoom: 14.4746,
  );

  static const CameraPosition _kReitzParking = CameraPosition(
    target: LatLng(-29.645454, -82.348519),
    zoom: 18,
  );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kUniversityOfFlorida,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        myLocationEnabled: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_pin),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToUser,
        label: const Text('Current Location'),
        icon: const Icon(Icons.location_pin),
      ),
    );
  }

  Future<void> _goToTheReitz() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kReitzParking));
  }

  Future<void> _goToUser() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kUserPosition));
  }

  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
      _kUserPosition = CameraPosition(
        target: _userPosition,
        zoom: 18,
      );
      print('${placemark[0].name}');
    });
  }
}