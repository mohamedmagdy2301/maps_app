// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';

part 'route_state.dart';

class RouteCubit extends Cubit<RouteState> {
  RouteCubit() : super(RouteInitial());

  List<LatLng> routePoints = [];
  List<List<dynamic>> historyMarkers =
      SharedPreferencesManager.getData(key: historyKey) ?? [];
  List<dynamic> coords = [];
  double duration = 0;
  double distance = 0;
  String destinationName = "";
  LatLng? pointDestination;
  double zoomLevel = 15;

  Future<void> getDestinationRoute(
    Position currentLocation,
    LatLng destination,
    List<Marker> markers,
    MapController mapController,
  ) async {
    routePoints = [];
    pointDestination = destination;
    if (markers.length > 1) markers.removeRange(1, markers.length);

    markers.add(
      Marker(
        point: destination,
        alignment: Alignment.center,
        child: const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 40,
        ),
      ),
    );

    emit(DestinationRouteLoaded());
  }

  Future<void> getDiractionesRouteFromApi(
    BuildContext context,
    Position currentLocation,
    LatLng destination,
    List<Marker> markers,
    MapController mapController,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$orsApiUrl?api_key=$orsApiKey'
        '&start=${currentLocation.longitude},'
        '${currentLocation.latitude}&end=${destination.longitude},${destination.latitude}',
      ),
    );
    getDestinationRoute(currentLocation, destination, markers, mapController);

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['features'][0];
      coords = data['geometry']['coordinates'];
      duration = data['properties']['segments'][0]["duration"];
      distance = data['properties']['segments'][0]["distance"];
      routePoints = coords.map((coord) => LatLng(coord[1], coord[0])).toList();

      destinationName = await getLocationNameString(destination);
      historyMarkers.add([destinationName, duration, distance]);
      SharedPreferencesManager.setData(
        key: historyKey,
        value: historyMarkers,
      );

      emit(DirectionRouteLoaded(routePoints));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch route data'),
        ),
      );
      emit(RouteError());
    }
  }

  Future<String> getLocationNameString(LatLng location) async {
    Placemark place = await getLocationName(location);
    return '${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.country}';
  }

  double getZoomLevel() {
    if (distance > 350000) {
      zoomLevel = 4.5;
    } else if (distance > 260000) {
      zoomLevel = 5;
    } else if (distance > 180000) {
      zoomLevel = 5.5;
    } else if (distance > 95000) {
      zoomLevel = 6;
    } else if (distance > 80000) {
      zoomLevel = 6.5;
    } else if (distance > 75000) {
      zoomLevel = 7;
    } else if (distance > 70000) {
      zoomLevel = 7.5;
    } else if (distance > 65000) {
      zoomLevel = 8;
    } else if (distance > 60000) {
      zoomLevel = 8.5;
    } else if (distance > 55000) {
      zoomLevel = 9;
    } else if (distance > 50000) {
      zoomLevel = 9.5;
    } else if (distance > 45000) {
      zoomLevel = 10;
    } else if (distance > 40000) {
      zoomLevel = 10.5;
    } else if (distance > 35000) {
      zoomLevel = 11;
    } else if (distance > 30000) {
      zoomLevel = 11.5;
    } else if (distance > 25000) {
      zoomLevel = 12;
    } else if (distance > 20000) {
      zoomLevel = 12.5;
    } else if (distance > 15000) {
      zoomLevel = 13;
    } else if (distance > 10000) {
      zoomLevel = 13.5;
    } else if (distance > 5000) {
      zoomLevel = 14;
    } else {
      zoomLevel = 15;
    }

    return zoomLevel;
  }

  clearRoute(
    BuildContext context,
    GetLoctionCubit getLoctionCubit,
    List<Marker> markers,
  ) {
    routePoints.clear();
    if (markers.length > 1) markers.removeRange(1, markers.length);
    Navigator.pop(context);
    getLoctionCubit.mapController.move(
      LatLng(
        getLoctionCubit.currentLocation!.latitude,
        getLoctionCubit.currentLocation!.longitude,
      ),
      15,
    );
    emit(ClearRouteSuccess());
  }
}
