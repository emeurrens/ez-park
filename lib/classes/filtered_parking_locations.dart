import 'dart:math';

import 'package:ez_park/classes/parking_location.dart';
import 'package:ez_park/data/all_parking_locations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FilteredParkingLocations {
  late String searchQuery;
  late TimeOfDay timeQuery;
  late DateTime dateQuery;
  late Set<DecalType> decalQuery;
  late VehicleType vehicleTypeQuery;
  late int remainingSpotsMin;
  late double remainingProportionMin;
  Random random = Random(TimeOfDay.now().hashCode);

  late Map<String, ParkingLocation> filteredParkingLocations;
  late ParkingLocation selectedParkingLocation;

  FilteredParkingLocations(this.searchQuery,
      this.timeQuery,
      this.dateQuery,
      this.decalQuery,
      this.vehicleTypeQuery,
      this.remainingSpotsMin,
      this.remainingProportionMin,
      this.filteredParkingLocations);

  FilteredParkingLocations.defaultFilters(){
    setDefaultFilters();
    applyFilters();
  }

  void setDefaultFilters() {
    searchQuery = "";
    timeQuery = TimeOfDay.now();
    dateQuery = DateTime.now();
    decalQuery = {};
    vehicleTypeQuery = VehicleType.any;
    remainingSpotsMin = 0;
    remainingProportionMin = 0.0;
  }

  bool _dateTimeQueryIsRestricted(ParkingLocation parkingLocation) {
    TimeOfDay startTime = parkingLocation.restrictionStart;
    TimeOfDay endTime = parkingLocation.restrictionEnd;
    Set<int> restrictedDays = parkingLocation.restrictedDays;

    double start = startTime.hour + (startTime.minute / 60.0);
    double end = endTime.hour + (endTime.minute / 60.0);
    double query = timeQuery.hour + (timeQuery.minute / 60.0);

    return query >= start && query <= end && restrictedDays.contains(dateQuery.weekday);
  }

  void applyFilters(){
    Map<String, ParkingLocation> newMap = {};

    allParkingLocations.forEach((name, parkingLocation) {
      //Randomizes the parking locations current occupancy. AKA generates fake data
      parkingLocation.currentOccupancy = random.nextInt(parkingLocation.maxCapacity);

      bool meetsCriteria = true;
      int remainingSpots = parkingLocation.maxCapacity -
          parkingLocation.currentOccupancy;
      double remainingProportion = remainingSpots /
          parkingLocation.maxCapacity.toDouble();

      if (!name.contains(RegExp(searchQuery, caseSensitive: false))) {
        meetsCriteria = false;
      } else if (remainingSpots < remainingSpotsMin) {
        meetsCriteria = false;
      } else if (remainingProportion < remainingProportionMin) {
        meetsCriteria = false;
      }

      if (_dateTimeQueryIsRestricted(parkingLocation) && !parkingLocation.validDecal(decalQuery)) {
        meetsCriteria = false;
      }

      if(!parkingLocation.validVehicleType(vehicleTypeQuery)) {
        meetsCriteria = false;
      }

      if (meetsCriteria) {
        newMap[name] = parkingLocation;
      }
    });

    filteredParkingLocations = newMap;

    if(filteredParkingLocations.isEmpty) {
      filteredParkingLocations[defaultParkingLocation.name] = defaultParkingLocation;
      selectedParkingLocation = defaultParkingLocation;
    } else {
      selectedParkingLocation = filteredParkingLocations[filteredParkingLocations.keys.first]!;
    }
  }

  ParkingLocation selectParkingLocation(String name) {
    selectedParkingLocation = filteredParkingLocations[name]!;
    return selectedParkingLocation;
  }

}

FilteredParkingLocations currentParkingLocations = FilteredParkingLocations.defaultFilters();
