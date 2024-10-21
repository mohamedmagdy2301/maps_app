import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';

class IconButtonGoMyLocation extends StatelessWidget {
  const IconButtonGoMyLocation({super.key});

  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    return FloatingActionButton(
      heroTag: 'currentLocation',
      backgroundColor: Colors.white,
      mini: true,
      onPressed: () {
        if (getLoctionCubit.currentLocation != null) {
          getLoctionCubit.mapController.move(
            LatLng(
              getLoctionCubit.currentLocation!.latitude,
              getLoctionCubit.currentLocation!.longitude,
            ),
            15,
          );
        }
      },
      child: const Icon(
        Icons.my_location,
        color: Colors.blue,
        size: 20,
      ),
    );
  }
}
