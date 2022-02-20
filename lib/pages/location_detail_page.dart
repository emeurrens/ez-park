import 'package:ez_park/classes/filtered_parking_locations.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class LocationDetailPage extends StatefulWidget {
  const LocationDetailPage({Key? key}) : super(key: key);

  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  void _launchMapsUrl() async {
    double lat =
        currentParkingLocations.selectedParkingLocation.location.latitude;
    double lng =
        currentParkingLocations.selectedParkingLocation.location.longitude;

    MapsLauncher.launchCoordinates(lat, lng);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Parking Details"),
      ),
      backgroundColor: Colors.grey[300],
      body: LayoutBuilder(
          builder: (context, constraints) => ListView(children: [
                Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          height: 150,
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/en/thumb/1/14/Florida_Gators_gator_logo.svg/1200px-Florida_Gators_gator_logo.svg.png'),
                        ),
                        Text(
                          currentParkingLocations.selectedParkingLocation.name,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentParkingLocations.selectedParkingLocation
                              .formatNotes(),
                          style: const TextStyle(
                              fontSize: 16, fontStyle: FontStyle.italic),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Applicable Decals",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentParkingLocations.selectedParkingLocation
                              .decalsToString(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Restricted Times",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                              textAlign: TextAlign.center,
                            ),
                            currentParkingLocations
                                    .selectedParkingLocation.isVerified
                                ? (const Tooltip(
                                    message: 'Verified',
                                    child: Icon(Icons.check_circle,
                                        color: Colors.green, size: 24)))
                                : const Tooltip(
                                    message: 'Not yet verified',
                                    child: Icon(Icons.cancel_outlined,
                                        color: Colors.redAccent, size: 24)),
                          ],
                        ),
                        Text(
                          currentParkingLocations.selectedParkingLocation
                              .restrictedDaysToString(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          currentParkingLocations.selectedParkingLocation
                              .restrictedTimesToString(),
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                        Row (
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Lot Size",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            Text(
                              ": " + currentParkingLocations.selectedParkingLocation
                                  .lotSizeToString(),
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        Container(
                            padding: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              child: const Text("Open in Maps app"),
                              onPressed: _launchMapsUrl,
                            ))
                      ]
                    ))
              ])));
}
