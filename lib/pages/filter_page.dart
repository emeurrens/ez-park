import 'package:ez_park/classes/filtered_parking_locations.dart';
import 'package:ez_park/classes/parking_location.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  final formKey = GlobalKey<FormState>();
  Set<DecalType> _decals = currentParkingLocations.decalQuery;
  VehicleType _vehicleType = currentParkingLocations.vehicleTypeQuery;
  DateTime _selectedDate = currentParkingLocations.dateQuery;
  double _sliderValue = currentParkingLocations.remainingProportionMin * 100;
  TimeOfDay _selectedTime = currentParkingLocations.timeQuery;
  String _searchValue = currentParkingLocations.searchQuery;

  void _applyFilters() {
    currentParkingLocations.searchQuery = _searchValue;
    currentParkingLocations.decalQuery = _decals;
    currentParkingLocations.vehicleTypeQuery = _vehicleType;
    currentParkingLocations.timeQuery = _selectedTime;
    currentParkingLocations.dateQuery = _selectedDate;
    currentParkingLocations.remainingProportionMin = _sliderValue / 100.0;
    currentParkingLocations.applyFilters();
  }

  void _resetFilters() {
    currentParkingLocations.setDefaultFilters();
    currentParkingLocations.applyFilters();
    _setFiltersFromQuery();
  }

  void _setFiltersFromQuery() {
    setState(() {
      _decals = currentParkingLocations.decalQuery;
      _vehicleType = currentParkingLocations.vehicleTypeQuery;
      _selectedDate = currentParkingLocations.dateQuery;
      _sliderValue = currentParkingLocations.remainingProportionMin * 100;
      _selectedTime = currentParkingLocations.timeQuery;
      _searchValue = currentParkingLocations.searchQuery;
    });
  }

  @override
  void initState() {
    super.initState();
    _setFiltersFromQuery();
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> show() async {
    final TimeOfDay? result =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        _selectedTime = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text("Filters"),
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Select Your Decal Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButton<DecalType>(
                        value: _decals.isEmpty ? DecalType.none : _decals.first,
                        items: const <DropdownMenuItem<DecalType>>[
                          DropdownMenuItem<DecalType>(
                              value: DecalType.none, child: Text("None")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.blue, child: Text("Blue")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.brown2, child: Text("Brown 2")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.brown3, child: Text("Brown 3")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.gold, child: Text("Gold")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.green, child: Text("Green")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.medResident,
                              child: Text("Medical Resident")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.motorcycleScooter,
                              child: Text("Motorcycle/Scooter")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.orange, child: Text("Orange")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.parkAndRide,
                              child: Text("Park & Ride")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.red1, child: Text("Red 1")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.red3, child: Text("Red 3")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.shandsYellow,
                              child: Text("Shands Yellow")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.silver, child: Text("Silver")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.staffCommuter,
                              child: Text("Staff Commuter")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.visitor, child: Text("Visitor")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.disabledEmployee,
                              child: Text("Disabled Employee")),
                          DropdownMenuItem<DecalType>(
                              value: DecalType.disabledStudent,
                              child: Text("Disabled Student")),
                        ],
                        onChanged: (DecalType? value) {
                          setState(() {
                            _decals = <DecalType>{value!};
                          });
                        },
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Text(
                    "Select Your Vehicle Type",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                      padding: const EdgeInsets.all(16),
                      child: DropdownButton<VehicleType>(
                        value: _vehicleType,
                        items: const <DropdownMenuItem<VehicleType>>[
                          DropdownMenuItem<VehicleType>(
                              value: VehicleType.any, child: Text("Any")),
                          DropdownMenuItem<VehicleType>(
                              value: VehicleType.car, child: Text("Car")),
                          DropdownMenuItem<VehicleType>(
                              value: VehicleType.scooter,
                              child: Text("Scooter/Motorcycle")),
                        ],
                        onChanged: (VehicleType? value) {
                          setState(() {
                            _vehicleType = value!;
                          });
                        },
                      )),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextField(
                        onChanged: (String value) {
                          _searchValue = value;
                        },
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            labelText: "Search by Name"),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "${_selectedDate.toLocal()}".split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _selectDate(context),
                            child: const Text(
                              "Select Date",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              _selectedTime.format(context),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: show,
                            child: const Text("Select Time",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          child: const Text("Apply Filters"),
                          onPressed: _applyFilters,
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                        ),
                        ElevatedButton(
                          child: const Text("Reset Filters"),
                          onPressed: _resetFilters,
                          style: ElevatedButton.styleFrom(
                              primary: Colors.redAccent),
                        )
                      ])
                ],
              ))));
}
