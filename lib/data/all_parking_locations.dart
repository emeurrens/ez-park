import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/parking_location.dart';

final Map<String, ParkingLocation> allParkingLocations = {
  "University of Florida": ParkingLocation.usingEnums(
      const LatLng(29.64378349411012, -82.35473240870209),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold}, 
      LotSize.large),
  "Parking Garage 1": ParkingLocation.usingEnums(
      const LatLng(29.641149556075867, -82.34199262916447),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 2": ParkingLocation.usingEnums(
      const LatLng(29.639044308094146, -82.3466793003293),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 3": ParkingLocation.usingEnums(
      const LatLng(29.638855333837878, -82.34770275799971),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 4": ParkingLocation.usingEnums(
      const LatLng(29.645481407606056, -82.34265756011877),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 5": ParkingLocation.usingEnums(
      const LatLng(29.643377553276224, -82.35127111567834),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 7": ParkingLocation.usingEnums(
      const LatLng(29.65083713340108, -82.3514484291643),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 8": ParkingLocation.usingEnums(
      const LatLng(29.645654973226762, -82.3373295408125),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 9": ParkingLocation.usingEnums(
      const LatLng(29.636633711889722, -82.34906774450533),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 10": ParkingLocation.usingEnums(
      const LatLng(29.64077880536279, -82.34159892916448),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 11": ParkingLocation.usingEnums(
      const LatLng(29.636563339729435, -82.36840412916462),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 12": ParkingLocation.usingEnums(
      const LatLng(29.645454, -82.348519),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 13": ParkingLocation.usingEnums(
      const LatLng(29.640635006238675, -82.34961670032926),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
  "Parking Garage 14": ParkingLocation.usingEnums(
      const LatLng(29.642131205385176, -82.35130385565841),
      const TimeOfDay(hour: 8, minute: 30),
      const TimeOfDay(hour: 15, minute: 30),
      DayRestrictions.weekdays,
      <DecalType>{DecalType.gold},
      LotSize.large),
};
