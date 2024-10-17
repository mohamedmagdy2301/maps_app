import 'dart:convert';

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
              point: destination,
              alignment: Alignment.center,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30,
              ),
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
                Expanded(
                  child: FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: LatLng(
                        currentLocation!.latitude,
                        currentLocation!.longitude,
                      ),
                      initialZoom: 16,
                      keepAlive: true,
                      onTap: (tapPosition, point) => getRouteFromApi(point),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: urlTemplate,
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
      floatingActionButton: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          routePoints.isNotEmpty
              ? FloatingActionButton(
                  heroTag: 'btn1',
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    showAdaptiveDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("اختر الموقع"),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                          actionsAlignment: MainAxisAlignment.end,
                          actions: [
                            TextButton(
                              onPressed: () {
                                clearRoute();
                                Navigator.pop(context);
                              },
                              child: const Text("مسح المسار"),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("رجوع")),
                          ],
                          content: DestinationDataWidget(
                            destinationName: destinationName,
                            distanceRoute: distanceRoute,
                            durationRoute: durationRoute,
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 20,
                  ),
                )
              : const SizedBox(),
          const Spacer(),
          FloatingActionButton(
            heroTag: 'currentLocation',
            backgroundColor: Colors.white,
            mini: true,
            onPressed: () {
              if (currentLocation != null) {
                mapController.move(
                  LatLng(currentLocation!.latitude, currentLocation!.longitude),
                  15,
                );
              }
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.blue,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
