import 'dart:developer';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}

Future<Placemark> getLocationName(LatLng position) async {
  // 30.99674449616613,30.56313391804571

  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  if (placemarks.isNotEmpty) {
    log(placemarks.first.toString());
    return placemarks.first;
  }
  return const Placemark(name: 'موقعك الحالي');
}

viewDistance(distanceRoute) {
  if (distanceRoute > 1000) {
    return 'المسافة: ${(distanceRoute / 1000).toStringAsFixed(1)} كم';
  }
  return 'المسافة: ${(distanceRoute).toStringAsFixed(0)} متر';
}

viewDuration(durationRoute) {
  if (durationRoute > 60) {
    if (durationRoute > 3600) {
      return 'المدة: ${(durationRoute / 3600).toStringAsFixed(1)} ساعة';
    }
    return 'المدة: ${(durationRoute / 60).toStringAsFixed(1)} دقيقة';
  }
  return 'المدة: ${(durationRoute).toStringAsFixed(0)} ثانية';
}
