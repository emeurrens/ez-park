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
  late int remainingSpotsMin;
  late double remainingProportionMin;

  late Map<String, ParkingLocation> filteredParkingLocations;

  FilteredParkingLocations(this.searchQuery,
      this.timeQuery,
      this.dateQuery,
      this.decalQuery,
      this.remainingSpotsMin,
      this.remainingProportionMin,
      this.filteredParkingLocations);

  FilteredParkingLocations.defaultFilters(){
    _setDefaultFilters();
    applyFilters();
  }

  void _setDefaultFilters() {
    searchQuery = "";
    timeQuery = TimeOfDay.now();
    dateQuery = DateTime.now();
    decalQuery = {};
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
      bool meetsCriteria = true;
      int remainingSpots = parkingLocation.maxCapacity -
          parkingLocation.currentOccupancy;
      double remainingProportion = remainingSpots /
          parkingLocation.maxCapacity.toDouble();

      if (!name.contains(searchQuery)) {
        meetsCriteria = false;
      } else if (remainingSpots < remainingSpotsMin) {
        meetsCriteria = false;
      } else if (remainingProportion < remainingProportionMin) {
        meetsCriteria = false;
      }

      if (_dateTimeQueryIsRestricted(parkingLocation) && decalQuery
          .intersection(parkingLocation.requiredDecals)
          .isEmpty) {
        meetsCriteria = false;
      }

      if (meetsCriteria) {
        newMap[name] = parkingLocation;
      }
    });

    filteredParkingLocations = newMap;
    filteredParkingLocations[defaultParkingLocation.name] = defaultParkingLocation;
  }

}

FilteredParkingLocations currentParkingLocations = FilteredParkingLocations.defaultFilters();
