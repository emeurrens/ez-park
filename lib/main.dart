import 'dart:async';

import 'package:flutter/material.dart';
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
  Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kUniversityOfFlorida = CameraPosition(
    target: LatLng(29.64378349411012, -82.35473240870209),
    zoom: 14.4746,
  );

  static const CameraPosition _kReitzParking = CameraPosition(
    target: LatLng(29.645454, -82.348519),
    zoom: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kUniversityOfFlorida,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheReitz,
        label: const Text('To the Reitz!'),
        icon: const Icon(Icons.directions),
      ),
    );
  }

  Future<void> _goToTheReitz() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kReitzParking));
  }
}