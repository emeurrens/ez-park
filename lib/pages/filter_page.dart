import 'package:ez_park/classes/filtered_parking_locations.dart';
import 'package:ez_park/classes/parking_location.dart';
import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  Set<DecalType> _decals = currentParkingLocations.decalQuery;
  final formKey = GlobalKey<FormState>();
  DateTime _selectedDate = currentParkingLocations.dateQuery;
  double _sliderValue = currentParkingLocations.remainingProportionMin * 100;
  TimeOfDay _selectedTime = currentParkingLocations.timeQuery;

  _applyFilters() {
    currentParkingLocations.decalQuery = _decals;
    currentParkingLocations.timeQuery = _selectedTime;
    currentParkingLocations.dateQuery = _selectedDate;
    currentParkingLocations.remainingProportionMin = _sliderValue / 100.0;
    currentParkingLocations.applyFilters();
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
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
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
            Container(
              padding: const EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: false,
                title: const Text("Decals"),
                dataSource: const [
                  {"display": "Blue", "value": DecalType.blue},
                  {"display": "Brown 2", "value": DecalType.brown2},
                  {"display": "Brown 3", "value": DecalType.brown3},
                  {"display": "Gold", "value": DecalType.gold},
                  {"display": "Green", "value": DecalType.green},
                  {"display": "Medical Resident", "value": DecalType.medResident},
                  {"display": "Motorcycle/Scooter", "value": DecalType.motorcycleScooter},
                  {"display": "Orange", "value": DecalType.orange},
                  {"display": "Park & Ride", "value": DecalType.parkAndRide},
                  {"display": "Red 1", "value": DecalType.red1},
                  {"display": "Red 3", "value": DecalType.red3},
                  {"display": "Shands South", "value": DecalType.shandsSouth},
                  {"display": "Silver", "value": DecalType.silver},
                  {"display": "Staff Commuter", "value": DecalType.staffCommuter},
                  {"display": "Visitor", "value": DecalType.visitor},
                  {"display": "Disabled Employee", "value": DecalType.disabledEmployee},
                  {"display": "Disabled Student", "value": DecalType.disabledStudent},
                ],
                textField: "display",
                valueField: "value",
                okButtonLabel: "OK",
                cancelButtonLabel: "CANCEL",
                hintWidget:
                    const Text("Choose the decals to filter by"),
                onSaved: (value) {
                  setState(() {
                    _decals = <DecalType>{};
                    for(DecalType decal in value){
                      _decals.add(decal);
                    }
                  });
                },
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${_selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(
                      fontSize: 30, 
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text(
                    "Select Date",
                    style: TextStyle(
                        color: Colors.black, 
                        fontWeight: FontWeight.bold
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Text(
                _selectedTime.format(context),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: show,
                child: const Text(
                  "Select Time",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 32.0,
                bottom: 0
              ),
              child: const Text(
                "Remaining Capacity Proportion",
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 0,
                bottom: 8.0
              ),
              child: Slider(
                value: _sliderValue,
                min: 0,
                max: 100,
                divisions: 10,
                label: _sliderValue.round().toString() + "%",
                onChanged: (double value) {
                  setState(() {
                    _sliderValue = value;
                  });
                },
              )  
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                child: const Text("Apply"),
                onPressed: _applyFilters,
              )
            )
          ],
        )
      )
    )
  );
}
