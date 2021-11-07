import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static const Map<String, LatLng> _locationPositions = {
    "University of Florida": LatLng(29.64378349411012, -82.35473240870209),
    "Parking Garage 1": LatLng(29.641149556075867, -82.34199262916447),
    "Parking Garage 2": LatLng(29.639044308094146, -82.3466793003293),
    "Parking Garage 3": LatLng(29.638855333837878, -82.34770275799971),
    "Parking Garage 4": LatLng(29.645481407606056, -82.34265756011877),
    "Parking Garage 5": LatLng(29.643377553276224, -82.35127111567834),
    "Parking Garage 7": LatLng(29.65083713340108, -82.3514484291643),
    //AKA Norman Garage
    "Parking Garage 8": LatLng(29.645654973226762, -82.3373295408125),
    "Parking Garage 9": LatLng(29.636633711889722, -82.34906774450533),
    "Parking Garage 10": LatLng(29.64077880536279, -82.34159892916448),
    "Parking Garage 11": LatLng(29.636563339729435, -82.36840412916462),
    //AKA Reitz Union Garage
    "Parking Garage 12": LatLng(-29.645454, -82.348519),
    "Parking Garage 13": LatLng(29.640635006238675, -82.34961670032926),
    //AKA Commuter Lot
    "Parking Garage 14": LatLng(29.642131205385176, -82.35130385565841),
  };

  int _selectedIndex = 0;
  static LatLng _userPosition = _locationPositions["University of Florida"] ?? const LatLng(0,0);
  static LatLng _targetPosition = _locationPositions["University of Florida"] ?? const LatLng(0,0);

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
      _selectedIndex = index;

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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_walk),
            label: '{{open in gmaps}}',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_alt),
            label: 'Filters',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple[800],
        onTap: _onItemTapped,
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
        _targetPosition = _locationPositions[markerId.value] ?? _userPosition;
        mapMarkers[markerId] = newMarker;
      });
    }
  }

  void _addMarkers() {
    setState(() {
      _locationPositions.forEach((name, latLng) {
        MarkerId markerId = MarkerId(name);
        Marker marker = Marker(
          markerId: markerId,
          position: latLng,
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
        _locationPositions.forEach((name, latLng) {
          int distanceFromUser = haversineDistance(_userPosition, latLng);
          if(distanceFromUser < minDistance){
            minDistance = distanceFromUser;
            _setTargetLocation(latLng);
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

  void _launchMapsUrl(LatLng latlng) async {
    double lat = latlng.latitude;
    double lng = latlng.longitude;

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