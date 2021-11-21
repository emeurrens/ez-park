import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

enum DecalType {
  gold,
  silver,
  official,
  orange,
  disabledEmployee,
  disabledStudent,
  blue,
  green,
  medResident,
  shandsSouth,
  staffCommuter,
  carpool,
  motorcycleScooter,
  parkAndRide,
  red1,
  red3,
  brown2,
  brown3
}

class ParkingLocation {
  LatLng location;
  TimeOfDay restrictionStart;
  TimeOfDay restrictionEnd;
  Set<String> restrictedDays;
  Set<DecalType> requiredDecals;


  ParkingLocation(
      this.location,
      this.restrictionStart,
      this.restrictionEnd,
      this.restrictedDays,
      this.requiredDecals
  );
}

Set<String> weekdays = <String>{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday"};
Set<String> weekends = <String>{"Saturday", "Sunday"};

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller = Completer();

  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;

  static final Map<String, ParkingLocation> _locationPositions = {
    "University of Florida": ParkingLocation(const LatLng(29.64378349411012, -82.35473240870209), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 1": ParkingLocation(const LatLng(29.641149556075867, -82.34199262916447), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 2": ParkingLocation(const LatLng(29.639044308094146, -82.3466793003293), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 3": ParkingLocation(const LatLng(29.638855333837878, -82.34770275799971), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 4": ParkingLocation(const LatLng(29.645481407606056, -82.34265756011877), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 5": ParkingLocation(const LatLng(29.643377553276224, -82.35127111567834), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 7": ParkingLocation(const LatLng(29.65083713340108, -82.3514484291643), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 8": ParkingLocation(const LatLng(29.645654973226762, -82.3373295408125), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 9": ParkingLocation(const LatLng(29.636633711889722, -82.34906774450533), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 10": ParkingLocation(const LatLng(29.64077880536279, -82.34159892916448), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 11": ParkingLocation(const LatLng(29.636563339729435, -82.36840412916462), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 12": ParkingLocation(const LatLng(29.645454, -82.348519), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 13": ParkingLocation(const LatLng(29.640635006238675, -82.34961670032926), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
    "Parking Garage 14": ParkingLocation(const LatLng(29.642131205385176, -82.35130385565841), const TimeOfDay(hour:8, minute: 30), const TimeOfDay(hour:15, minute: 30), weekdays, <DecalType>{DecalType.gold}),
  };

  static LatLng _userPosition = _locationPositions["University of Florida"]!.location;
  static LatLng _targetPosition = _locationPositions["University of Florida"]!.location;

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
        _targetPosition = _locationPositions[markerId.value]!.location;
        mapMarkers[markerId] = newMarker;
      });
    }
  }

  void _addMarkers() {
    setState(() {
      _locationPositions.forEach((name, parkingLocation) {
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
        _locationPositions.forEach((name, parkingLocation) {
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