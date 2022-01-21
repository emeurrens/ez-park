import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  brown3,
  visitor,
  none
}

enum VehicleType {
  any,
  car,
  scooter
}

const Map<DecalType, Set<DecalType>> allApplicableZones = {
  DecalType.gold: <DecalType>{DecalType.gold, DecalType.orange, DecalType.blue, DecalType.green, DecalType.red1, DecalType.red3, DecalType.brown2, DecalType.brown3, DecalType.parkAndRide},
  DecalType.silver: <DecalType>{DecalType.silver},
  DecalType.official: <DecalType>{DecalType.official, DecalType.orange, DecalType.blue, DecalType.green, DecalType.red1, DecalType.red3, DecalType.brown3, DecalType.brown2, DecalType.parkAndRide},
  DecalType.orange: <DecalType>{DecalType.orange, DecalType.green, DecalType.parkAndRide},
  DecalType.disabledEmployee: <DecalType>{DecalType.disabledEmployee, DecalType.disabledStudent, DecalType.parkAndRide},
  DecalType.disabledStudent: <DecalType>{DecalType.disabledStudent, DecalType.disabledEmployee, DecalType.parkAndRide},
  DecalType.blue: <DecalType>{DecalType.blue, DecalType.green, DecalType.parkAndRide},
  DecalType.green: <DecalType>{DecalType.green, DecalType.parkAndRide},
  DecalType.medResident: <DecalType>{DecalType.medResident, DecalType.orange, DecalType.green, DecalType.red1, DecalType.red3, DecalType.brown2, DecalType.brown3, DecalType.parkAndRide},
  DecalType.shandsSouth: <DecalType>{DecalType.shandsSouth},
  DecalType.staffCommuter: <DecalType>{DecalType.staffCommuter, DecalType.green},
  DecalType.carpool: <DecalType>{DecalType.carpool, DecalType.orange, DecalType.blue, DecalType.green, DecalType.parkAndRide},
  DecalType.motorcycleScooter: <DecalType>{DecalType.motorcycleScooter},
  DecalType.parkAndRide: <DecalType>{DecalType.parkAndRide},
  DecalType.red1: <DecalType>{DecalType.red1, DecalType.red3, DecalType.parkAndRide},
  DecalType.red3: <DecalType>{DecalType.red3},
  DecalType.brown2: <DecalType>{DecalType.brown2, DecalType.parkAndRide},
  DecalType.brown3: <DecalType>{DecalType.brown3, DecalType.parkAndRide},
  DecalType.visitor: <DecalType>{DecalType.visitor},
  DecalType.none: <DecalType>{},
};

enum DayRestrictions {
  weekends,
  weekdays,
  all,
  none
}

enum LotSize {
  large,
  medium,
  small
}

enum TimeRestrictions {
  standard,
  extended,
  allDay
}

//Corresponds to weekday number from DateTime.weekday
const Set<int> weekdays = <int>{
  1, //monday
  2, //tuesday
  3, //wednesday
  4, //thursday
  5 //friday
};

const Set<int> weekends = <int>{
  6, //saturday
  7 //sunday
};

class ParkingLocation {
  late String name;
  late LatLng location;
  late TimeOfDay restrictionStart;
  late TimeOfDay restrictionEnd;
  late Set<int> restrictedDays;
  late Set<DecalType> requiredDecals;
  late int maxCapacity;
  late int currentOccupancy = 0;


  ParkingLocation(this.name,
      this.location,
      this.restrictionStart,
      this.restrictionEnd,
      this.restrictedDays,
      this.requiredDecals,
      this.maxCapacity);

  ParkingLocation.usingEnums(String locName, LatLng loc, TimeRestrictions timeRestrictions,
      DayRestrictions dayRestrictions, Set<DecalType> reqDecals, LotSize lotSize){
    name = locName;
    location = loc;
    requiredDecals = reqDecals;

    if(timeRestrictions == TimeRestrictions.allDay) {
      restrictionStart = const TimeOfDay(hour: 0, minute: 0);
      restrictionEnd = const TimeOfDay(hour: 23, minute: 59);
    } else if (timeRestrictions == TimeRestrictions.extended) {
      restrictionStart = const TimeOfDay(hour: 7, minute: 30);
      restrictionEnd = const TimeOfDay(hour: 17, minute: 30);
    } else {
      restrictionStart = const TimeOfDay(hour: 8, minute: 30);
      restrictionEnd = const TimeOfDay(hour: 15, minute: 30);
    }

    if (dayRestrictions == DayRestrictions.all) {
      restrictedDays = weekdays.union(weekends);
    } else if (dayRestrictions == DayRestrictions.weekends) {
      restrictedDays = weekends;
    } else if (dayRestrictions == DayRestrictions.weekdays) {
      restrictedDays = weekdays;
    } else {
      restrictedDays = <int>{};
    }

    if (lotSize == LotSize.large) {
      maxCapacity = 500;
    } else if (lotSize == LotSize.medium) {
      maxCapacity = 200;
    } else {
      maxCapacity = 50;
    }
  }

  String decalsToString() {
    if(requiredDecals.isEmpty){
      return "None";
    }

    String decalString = "";

    int decalCount = requiredDecals.length;

    for (var element in requiredDecals) {
      decalString += element.toString().split('.').last;
      decalCount -= 1;
      if(decalCount > 0){
        decalString += ", ";
      }
    }

    return decalString;
  }

  String restrictedDaysToString() {
    if(restrictedDays.isEmpty) {
      return "None";
    }
    List orderedDays = [...restrictedDays];
    orderedDays.sort();

    Map<int, String> dayNameMap = {
      1: "Mon",
      2: "Tue",
      3: "Wed",
      4: "Thur",
      5: "Fri",
      6: "Sat",
      7: "Sun"
    };

    String output = "";

    int dayCount = restrictedDays.length;
    if(dayCount == 7){
      return "Every day";
    }

    for (var dayNum in orderedDays) {
      output += dayNameMap[dayNum]!;
      dayCount -= 0;
      if(dayCount > 0){
        output += ", ";
      }
    }

    return output;
  }

  String restrictedTimesToString() {
    if(restrictionStart == const TimeOfDay(hour: 0, minute:0) &&
        restrictionEnd == const TimeOfDay(hour: 23, minute: 59)){
      return "All day";
    }

    String ampmStart = (restrictionStart.hour / 12 >= 1 ? "pm" : "am");
    String ampmEnd = (restrictionEnd.hour / 12 >= 1 ? "pm" : "am");

    return (restrictionStart.hour % 12).toString() + ":" +
        restrictionStart.minute.toString() + ampmStart +
        " - " + (restrictionEnd.hour % 12).toString() + ":" +
        restrictionEnd.minute.toString() + ampmEnd;
  }

  bool validDecal(Set<DecalType> decalSet) {
    Set<DecalType> possibleMatches = <DecalType>{};

    for(var decal in decalSet) {
      possibleMatches = possibleMatches.union(allApplicableZones[decal]!);
    }

    for(var decal in possibleMatches) {
      if(requiredDecals.contains(decal)) {
        return true;
      }
    }
    return false;
  }

  bool validVehicleType(VehicleType vehicleTypeQuery) {
    if(vehicleTypeQuery == VehicleType.car &&
        requiredDecals.contains(DecalType.motorcycleScooter) &&
        requiredDecals.length == 1){
      return false;
    }

    if(vehicleTypeQuery == VehicleType.scooter &&
        !requiredDecals.contains(DecalType.motorcycleScooter)){
      return false;
    }

    return true;
  }
}
