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

const Set<String> weekdays = <String>{
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday"
};

const Set<String> weekends = <String>{
  "Saturday",
  "Sunday"
};

class ParkingLocation {
  late LatLng location;
  late TimeOfDay restrictionStart;
  late TimeOfDay restrictionEnd;
  late Set<String> restrictedDays;
  late Set<DecalType> requiredDecals;
  late int maxCapacity;
  late int currentOccupancy = 0;


  ParkingLocation(this.location,
      this.restrictionStart,
      this.restrictionEnd,
      this.restrictedDays,
      this.requiredDecals,
      this.maxCapacity);

  ParkingLocation.usingEnums(LatLng loc, TimeRestrictions timeRestrictions,
      DayRestrictions dayRestrictions, Set<DecalType> reqDecals, LotSize lotSize){
    location = loc;

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
      restrictedDays = <String>{};
    }

    if (lotSize == LotSize.large) {
      maxCapacity = 500;
    } else if (lotSize == LotSize.medium) {
      maxCapacity = 200;
    } else {
      maxCapacity = 50;
    }
  }

}
