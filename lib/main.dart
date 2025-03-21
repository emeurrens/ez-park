import 'package:ez_park/pages/location_detail_page.dart';
import 'widgets/navbar_widgets.dart';
import 'pages/map_view_page.dart';
import 'pages/filter_page.dart';
import 'pages/list_view_page.dart';
import 'package:flutter/material.dart';
import 'data/lot_database_client.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Run app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'EZ Park',
      home: MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<int> _dbLoadStatus = LotDatabaseClient.pollLotsFromDB();

  int _selectedIndex = 0;
  final List<Widget> screens = [
    const MapSample(),
    const ListViewPage(),
    const FilterPage(),
    const LocationDetailPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        // Attempt to load data from database
        future: _dbLoadStatus,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return screens[_selectedIndex];
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[300],
        items: <BottomNavigationBarItem>[
          mapViewPage(),
          listViewPage(),
          filterPage(),
          detailsPage(),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blue,
        selectedItemColor: Colors.deepOrange,
        onTap: _onItemTapped,
      ),
    );
  }
}
