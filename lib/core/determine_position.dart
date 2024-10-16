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

Future<String> getLocationName(LatLng position) async {
  // 30.99674449616613,30.56313391804571

  final placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  if (placemarks.isNotEmpty) {
    final place = placemarks.first;
    if (place.locality != null &&
        place.administrativeArea != null &&
        place.country != null) {
      return '${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
    if (place.locality != null && place.country != null) {
      return '${place.locality}, ${place.country}';
    }
    if (place.administrativeArea != null && place.country != null) {
      return '${place.administrativeArea}, ${place.country}';
    }
    if (place.country != null) {
      return '${place.country}';
    }
    if (place.locality != null) {
      return '${place.locality}';
    }
    if (place.administrativeArea != null) {
      return '${place.administrativeArea}';
    }
    if (place.subLocality != null) {
      return '${place.subLocality}';
    }
    if (place.subAdministrativeArea != null) {
      return '${place.subAdministrativeArea}';
    }
    if (place.subThoroughfare != null) {
      return '${place.subThoroughfare}';
    }
    if (place.thoroughfare != null) {
      return '${place.thoroughfare}';
    }
    if (place.name != null) {
      return '${place.name}';
    }
    if (place.postalCode != null) {
      return '${place.postalCode}';
    }
  }
  return 'Unknown Location';
}
