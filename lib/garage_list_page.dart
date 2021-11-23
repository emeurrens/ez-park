import 'package:flutter/material.dart';

class GarageListPage extends StatefulWidget {
  @override
  _GarageListPageState createState() => _GarageListPageState();
}

class _GarageListPageState extends State<GarageListPage> {
  List<String> garageList = ['Garage 1', 'Garage 2', 'Garage 3', 'Garage 4',
    'Garage 5', 'Garage 6', 'Garage 7', 'Garage 8', 'Garage 9', 'Garage 10',
    'Garage 11'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: garageList.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(
                garageList[index],
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
