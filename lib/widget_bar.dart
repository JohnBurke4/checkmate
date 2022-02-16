import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user_location/user_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  _NavBarState() {}

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  MapController mapController = MapController();
  late UserLocationOptions userLocationOptions;
  // ADD THIS
  List<Marker> markers = [];

  static List<Widget> _widgetOptions = <Widget>[
    // Put your widgets in here
    Text(
      'Index 0: Me',
      style: optionStyle,
    ),
    Text(
      'Index 1: Swipe',
      style: optionStyle,
    ),
    Text(
      'Index 2: Chat',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    StatefulWidget route;
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _selectedWidget(int index, BuildContext context) {
    if (index < 3) {
      return _widgetOptions.elementAt(_selectedIndex);
    } else {
      return FlutterMap(
        options: MapOptions(
          center: LatLng(0, 0),
          zoom: 15.0,
          plugins: [
            // ADD THIS
            UserLocationPlugin(),
          ],
        ),
        layers: [
          TileLayerOptions(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
            additionalOptions: {
              // Paste the access token from the token.txt
              'accessToken': '<access-token>>',
              'id': 'mapbox/streets-v11',
            },
          ),
          //MarkerLayerOptions(markers: markers),
          userLocationOptions,
        ],
        mapController: mapController,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('CheckMate')),
      ),
      body: _selectedWidget(_selectedIndex, context),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swipe),
            label: 'Swipe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
