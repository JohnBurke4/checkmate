import 'package:flutter/material.dart';
import 'package:user_location/user_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  List<Marker> markers = [];
  late UserLocationOptions userLocationOptions;

  @override
  Widget build(BuildContext context) {
    userLocationOptions = UserLocationOptions(
      context: context,
      mapController: mapController,
      markers: markers,
    );
    return Scaffold(
        body: FlutterMap(
      options: MapOptions(
        center: LatLng(0, 0),
        zoom: 15.0,
        plugins: [
          UserLocationPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}",
          additionalOptions: {
            // Paste the access token from the token.txt
            'accessToken':
                'pk.eyJ1IjoibmRray0wIiwiYSI6ImNremloa204cDFld3Uyd24yMjdxcTJlZjUifQ.3Di7cDFkBf-oKovlkYO_Tw',
            'id': 'mapbox/streets-v11',
          },
        ),
        //MarkerLayerOptions(markers: markers),
        userLocationOptions,
      ],
      mapController: mapController,
    ));
  }
}
