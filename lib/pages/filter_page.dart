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
                      fontSize: 55, fontWeight: FontWeight.bold),
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
              padding: EdgeInsets.all(8),
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
