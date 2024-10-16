import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/determine_position.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';
import 'package:openstreetmap/screens/history_screen.dart';
import 'package:openstreetmap/widgets/appbar_home.dart';
import 'package:openstreetmap/widgets/destination_data_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController mapController = MapController();
  Position? currentLocation;
  List<LatLng> routePoints = [];
  List<Marker> markers = [];
  List<List<dynamic>> historyMarkers =
      SharedPreferencesManager.getData(key: historyKey) ?? [];
  List<dynamic> coords = [];
  double durationRoute = 0;
  double distanceRoute = 0;
  String destinationName = "";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    Position userLocation = await determinePosition();
    setState(
      () {
        currentLocation = userLocation;
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(
              userLocation.latitude,
              userLocation.longitude,
            ),
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 30.0,
            ),
          ),
        );
      },
    );
  }

  Future<void> getRouteFromApi(LatLng destination) async {
    if (currentLocation == null) return;

    var start = LatLng(currentLocation!.latitude, currentLocation!.longitude);
    Placemark place = await getLocationName(destination);
    destinationName =
        '${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';

    final response = await http.get(
      Uri.parse(
          '$orsApiUrl?api_key=$orsApiKey&start=${start.longitude},${start.latitude}&end=${destination.longitude},${destination.latitude}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['features'][0];
      coords = data['geometry']['coordinates'];
      durationRoute = data['properties']['segments'][0]["duration"];
      distanceRoute = data['properties']['segments'][0]["distance"];

      setState(
        () {
          routePoints =
              coords.map((coord) => LatLng(coord[1], coord[0])).toList();
          historyMarkers.add([destinationName, durationRoute, distanceRoute]);
          SharedPreferencesManager.setData(
            key: historyKey,
            value: historyMarkers,
          );
          //! for current location and destination marker only
          if (markers.length > 1) markers.removeRange(1, markers.length);
          markers.add(
            Marker(
              width: 80.0,
              height: 80.0,
              point: destination,
              alignment: Alignment.center,
              child:
                  const Icon(Icons.location_on, color: Colors.red, size: 40.0),
            ),
          );
        },
      );
    }
  }

  clearRoute() {
    setState(() {
      routePoints.clear();
      if (markers.length > 1) markers.removeRange(1, markers.length);
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarHome(
        onPressedClear: () {
          clearRoute();
        },
        onPressedHistory: () {
          Navigator.pushNamed(
            context,
            HistoryScreen.routeName,
            arguments: historyMarkers,
          );
        },
      ),
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                routePoints.isNotEmpty
                    ? DestinationDataWidget(
                        destinationName: destinationName,
                        distanceRoute: distanceRoute,
                        durationRoute: durationRoute,
                      )
                    : const SizedBox(),
                Expanded(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                      ),
                      initialZoom: 15,
                      onTap: (tapPosition, point) => getRouteFromApi(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: markers,
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            strokeWidth: 3.0,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: IconButton(
        onPressed: () {
          if (currentLocation != null) {
            mapController.move(
              LatLng(currentLocation!.latitude, currentLocation!.longitude),
              15,
            );
          }
        },
        icon: const Icon(
          CupertinoIcons.location_circle_fill,
          color: Colors.blue,
          size: 40,
        ),
      ),
    );
  }
}
