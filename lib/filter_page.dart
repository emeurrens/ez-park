import 'package:flutter/material.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class FilterPage extends StatefulWidget {
  @override
  State<FilterPage> createState() => FilterPageState();
}

class FilterPageState extends State<FilterPage> {
  List _decals = [];
  final formKey = GlobalKey<FormState>();
  String _results = "";
  DateTime selectedDate = DateTime.now();
  double _sliderValue = 0;
  String? selectedTime;

  @override
  void initState() {
    super.initState();
    _decals = [];
    _results = "";
    selectedDate = DateTime.now();
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        _results = _decals.toString();
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> show() async {
    final TimeOfDay? result = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (result != null) {
      setState(() {
        selectedTime = result.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text("Filters"),
    ),
    backgroundColor: Colors.grey[300],
    body: Center(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: MultiSelectFormField(
                autovalidate: false,
                title: Text("Decals"),
                dataSource: const [
                  {"display": "Red", "value": "Red"},
                  {"display": "Orange", "value": "Orange"},
                  {"display": "Green", "value": "Green"},
                  {"display": "Park & Ride", "value": "Park & Ride"},
                  {"display": "Motorcycle/Scooter", "value": "Motorcycle/Scooter"},
                  {"display": "Brown", "value": "Brown"},
                ],
                textField: "display",
                valueField: "value",
                okButtonLabel: "OK",
                cancelButtonLabel: "CANCEL",
                hintWidget:
                    const Text("Choose the decals to filter by"),
                onSaved: (value) {
                  setState(() {
                    _decals = value;
                  });
                },
              )
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  "${selectedDate.toLocal()}".split(' ')[0],
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
                selectedTime != null ? selectedTime! : 'Time not selected',
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
                "Percent Capacity Filled",
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
                label: _sliderValue.round().toString(),
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
                child: Text("Apply"),
                onPressed: _saveForm,
              )
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Text(_results),
            )
          ],
        )
      )
    )
  );
}
