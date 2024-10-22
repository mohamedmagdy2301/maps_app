import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';

class FlutterMapBuilder extends StatefulWidget {
  const FlutterMapBuilder({
    super.key,
    required this.points,
  });
  final List<LatLng> points;

  @override
  State<FlutterMapBuilder> createState() => _FlutterMapBuilderState();
}

class _FlutterMapBuilderState extends State<FlutterMapBuilder> {
  double zoom = 15;
  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    var routeCubit = context.read<RouteCubit>();
    var markers = context.read<GetLoctionCubit>().markers;
    return Stack(
      children: [
        FlutterMap(
          mapController: getLoctionCubit.mapController,
          options: MapOptions(
            initialCenter: LatLng(
              getLoctionCubit.currentLocation!.latitude,
              getLoctionCubit.currentLocation!.longitude,
            ),
            initialZoom: zoom,
            minZoom: 2.6,
            maxZoom: 20,
            onTap: (tapPosition, point) async {
              await routeCubit.getDestinationRoute(
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
                  points: widget.points,
                  strokeWidth: 3.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            IconButton(
              onPressed: () {
                if (zoom > 2.5) {
                  zoom -= 0.5;
                  getLoctionCubit.mapController.move(
                    getLoctionCubit.currentLocation!,
                    zoom,
                  );
                  log(zoom.toString());
                }
                setState(() {});
              },
              alignment: Alignment.center,
              icon: const Icon(
                CupertinoIcons.minus_circle_fill,
                color: Colors.black,
                size: 50,
              ),
            ),
            IconButton(
              onPressed: () {
                if (zoom <= 20) {
                  zoom += 0.5;
                  getLoctionCubit.mapController.move(
                    getLoctionCubit.currentLocation!,
                    zoom,
                  );
                  log(zoom.toString());
                }
                setState(() {});
              },
              alignment: Alignment.center,
              icon: const Icon(
                CupertinoIcons.add_circled_solid,
                color: Colors.black,
                size: 50,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
