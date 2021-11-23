import '../data/all_parking_locations.dart';

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static LatLng _userPosition = allParkingLocations["UF Bookstore & Welcome Center"]!.location;
  static LatLng _targetPosition = allParkingLocations["UF Bookstore & Welcome Center"]!.location;

  static CameraPosition _kUserPosition = CameraPosition(
    target: _userPosition,
    zoom: 18,
  );


  static CameraPosition _kTargetPosition = CameraPosition(
    target: _targetPosition,
    zoom: 18,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onItemTapped(int index) {
    setState(() {
      //_selectedIndex = index;

      if(index == 1){
        _launchMapsUrl(_targetPosition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _kTargetPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          _addMarkers();
        },
        myLocationEnabled: true,
        markers: Set<Marker>.of(mapMarkers.values)
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          onPressed: _findClosestParking,
          label: const Text('Find nearest parking!'),
          icon: const Icon(Icons.location_pin),
        ),
      ),
    );
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = mapMarkers[markerId];
    if (tappedMarker != null) {
      setState(() {
        final MarkerId? previousMarkerId = selectedMarker;
        if (previousMarkerId != null && mapMarkers.containsKey(previousMarkerId)) {
          final Marker resetOld = mapMarkers[previousMarkerId]!
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          mapMarkers[previousMarkerId] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _targetPosition = allParkingLocations[markerId.value]!.location;
        mapMarkers[markerId] = newMarker;
      });
    }
  }

  void _addMarkers() {
    setState(() {
      allParkingLocations.forEach((name, parkingLocation) {
        MarkerId markerId = MarkerId(name);
        Marker marker = Marker(
          markerId: markerId,
          position: parkingLocation.location,
          infoWindow: InfoWindow(title: name, snippet: '*'),
          onTap: () {
            _onMarkerTapped(markerId);
          },
        );
        mapMarkers[markerId] = marker;
      });
    });
  }

  Future<void> _goToTargetLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kTargetPosition));
  }

  //it looks like the gmaps api has this included already, will keep for now.
  Future<void> _goToUser() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kUserPosition));
  }

  Future<void> _findClosestParking() async {
    final GoogleMapController controller = await _controller.future;
    await _getUserLocation().then((value) => setState(() {
        int minDistance = 0x7fffffffffffffff; //int max
        allParkingLocations.forEach((name, parkingLocation) {
          int distanceFromUser = haversineDistance(_userPosition, parkingLocation.location);
          if(distanceFromUser < minDistance){
            minDistance = distanceFromUser;
            _setTargetLocation(parkingLocation.location);
          }
        });
        _goToTargetLocation();
    }));

    controller.animateCamera(CameraUpdate.newCameraPosition(_kUserPosition));
  }

  Future<void> _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _userPosition = LatLng(position.latitude, position.longitude);
      _kUserPosition = CameraPosition(
        target: _userPosition,
        zoom: 19,
      );
    });
  }
  
  void _setTargetLocation(LatLng latLng) async {
    setState(() {
      _targetPosition = latLng;
      _kTargetPosition = CameraPosition(
        target: _targetPosition,
        zoom: 18,
      );
    });
  }

  void _launchMapsUrl(LatLng latLng) async {
    double lat = latLng.latitude;
    double lng = latLng.longitude;

    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  /*
  Approximate distance between two latitude/longitude points on a sphere
  https://en.wikipedia.org/wiki/Haversine_formula

  R = earth's radius = 6371000m
   */
  int haversineDistance(LatLng point1, LatLng point2) {
    double phi1 = point1.latitude;
    double phi2 = point2.latitude;
    double lam1 = point1.longitude;
    double lam2 = point2.longitude;
    int R = 6371000;

    return (2 * R *
        asin( sqrt( pow(sin((phi2-phi1)/2), 2) +
            cos(phi1)*cos(phi2)*pow(sin((lam2-lam1)/2),2))
        )).toInt();
  }
}