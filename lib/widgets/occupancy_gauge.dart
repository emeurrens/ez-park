import 'dart:async';
import 'dart:convert';

import 'package:ez_park/data/psql_api_wrapper.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import '../classes/parking_location.dart';
import '../data/all_parking_locations.dart';

class OccupancyGauge extends StatefulWidget {
  const OccupancyGauge({
    super.key,
    required this.lotName,
  });

  final String lotName;

  @override
  State<OccupancyGauge> createState() => _OccupancyGaugeState();
}

class _OccupancyGaugeState extends State<OccupancyGauge> {
  // database polling timer
  late Timer timer;

  // gauge variables
  int occupancy = 80;
  int capacity = 100;
  Color color = const Color(0xFF00007F);
  late CircularPercentIndicator circularIndicator;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 10), (timer) => checkOccupancy());
    checkOccupancy();
  }

  void checkOccupancy() async {
    // Update local parking location data according to database information
    print(widget.lotName + " " + allParkingLocations[widget.lotName]!.lotID);
    Map<String, dynamic> jsonInput = jsonDecode(await getLot(allParkingLocations[widget.lotName]!.lotID) as String);
    jsonInput.putIfAbsent("LotID", () => allParkingLocations[widget.lotName]!.lotID);  // Need to add lotID since lotID is not returned with getLot
    print(jsonInput);

    allParkingLocations[widget.lotName] =
        ParkingLocation.fromJson(jsonInput);
    print(allParkingLocations[widget.lotName]!.toJson());

    setState(() {
      // Update occupancy information for gauge
      occupancy = allParkingLocations[widget.lotName]!.currentOccupancy;
      capacity = allParkingLocations[widget.lotName]!.lotCapacity;

      // Update color according to occupancy percentage
      // If occupancy-capacity ratio is [0-0.4), make color green
      if (occupancy.toDouble() / capacity.toDouble() < 0.4) {
        color = const Color(0xFF00BF00);
      }
      // If occupancy-capacity ratio is 0.4-0.8, make color yellow
      else if (occupancy.toDouble() / capacity.toDouble() < 0.8) {
        color = const Color(0xFFFFCF00);
      }
      // If occupancy-capacity ratio is 0.8-1.0, make color red
      else {
        color = const Color(0xFFEF0000);
      }
    });

    /// TODO: Update circular gauge according to current occupancy
    /// (occupancy.toDouble()) / (capacity.toDouble())
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// TODO: Make circular indicator
  @override
  Widget build(BuildContext context) =>
      Center(
        child: CircularPercentIndicator(
          // Until radius reaches a certain maximum (120 in this case),
          // grow proportionally to screen
          radius: MediaQuery.sizeOf(context).width / 4.5 > 120.0 ? 120.0
              : MediaQuery.sizeOf(context).width / 4.5,
          // Width of line
          lineWidth: 16.0,
          // Percent of gauge filled
          percent: occupancy.toDouble() / capacity.toDouble(),
          progressColor: color,
          circularStrokeCap: CircularStrokeCap.square,
          startAngle: 0.0,
          animation: true,
          animateFromLastPercent: true,
          animateToInitialPercent: false,
          center: Text.rich(
              TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: "${capacity - occupancy}",
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 36),
                  ),
                  const TextSpan(
                    text: "\nspaces\n available",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, height: 1.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
          ),
        ),
      );
}

