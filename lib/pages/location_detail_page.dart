import 'dart:async';

import 'package:ez_park/classes/filtered_parking_locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetailPage extends StatefulWidget {
  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();
  }

  void _launchMapsUrl() async {
    double lat = currentParkingLocations.selectedParkingLocation.location.latitude;
    double lng = currentParkingLocations.selectedParkingLocation.location.longitude;

    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Parking Details"),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
            child: ListView(
              children: <Widget>[
                //This is where a streetview or simply an image of each parking location would go.
                const Image(
                  height: 200,
                  image: NetworkImage('https://snworksceo.imgix.net/ufa/04ff62c8-69c2-4e60-957f-6d46d5ed2555.sized-1000x1000.jpeg?w=1000'),
                ),
                const Text(
                  "Name",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  ),
                ),
                Text(
                  currentParkingLocations.selectedParkingLocation.name,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const Text(
                  "Applicable Decals",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  ),
                ),
                Text(
                  currentParkingLocations.selectedParkingLocation.decalsToString(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const Text(
                  "Restricted Days",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  ),
                ),
                Text(
                  currentParkingLocations.selectedParkingLocation.restrictedDaysToString(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const Text(
                  "Restricted Times",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  ),
                ),
                Text(
                  currentParkingLocations.selectedParkingLocation.restrictedTimesToString(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
                const Text(
                  "Remaining Capacity",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline
                  ),
                ),
                Text(
                  (currentParkingLocations.selectedParkingLocation.maxCapacity -
                      currentParkingLocations.selectedParkingLocation.currentOccupancy).toString()
                  + "/" + currentParkingLocations.selectedParkingLocation.maxCapacity.toString(),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal
                  ),
                ),
                Container(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      child: const Text("Open in Google Maps"),
                      onPressed: _launchMapsUrl,
                    )
                )
              ],
            )
          )
  );


}
