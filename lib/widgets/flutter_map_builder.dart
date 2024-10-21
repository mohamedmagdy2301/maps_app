import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';

class FlutterMapBuilder extends StatelessWidget {
  const FlutterMapBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    var routeCubit = context.read<RouteCubit>();
    var markers = context.read<GetLoctionCubit>().markers;
    return FlutterMap(
      mapController: getLoctionCubit.mapController,
      options: MapOptions(
        initialCenter: LatLng(
          getLoctionCubit.currentLocation!.latitude,
          getLoctionCubit.currentLocation!.longitude,
        ),
        initialZoom: 15,
        keepAlive: true,
        onTap: (tapPosition, point) async {
          await routeCubit.getRouteFromApi(
            getLoctionCubit.currentLocation!,
            point,
            markers,
            getLoctionCubit.mapController,
          );
        },
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
              points: routeCubit.routePoints,
              strokeWidth: 3.0,
              color: Colors.blue,
            ),
          ],
        ),
      ],
    );
  }
}
