import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/widgets/appbar_home.dart';
import 'package:openstreetmap/widgets/flutter_map_builder.dart';
import 'package:openstreetmap/widgets/icon_button_go_my_location.dart';
import 'package:openstreetmap/widgets/info_route_icon_botton.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    var markers = context.read<GetLoctionCubit>().markers;
    return BlocBuilder<GetLoctionCubit, GetLoctionState>(
      builder: (context, state) {
        if (state is GetLoctionSuccess) {
          return BlocConsumer<RouteCubit, RouteState>(
            listener: (context, state) {
              if (state is RouteError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                  ),
                );
              }
              if (state is ClearRouteSuccess) {
                if (markers.length > 1) {
                  markers.removeRange(
                    1,
                    markers.length,
                  );
                }
                Navigator.pop(context);
                getLoctionCubit.mapController.move(
                  LatLng(
                    getLoctionCubit.currentLocation!.latitude,
                    getLoctionCubit.currentLocation!.longitude,
                  ),
                  15,
                );
              }
            },
            builder: (context, state) {
              return const Scaffold(
                appBar: AppBarHome(),
                body: FlutterMapBuilder(),
                floatingActionButton: Column(
                  children: [
                    SizedBox(height: 100),
                    InfoRouteIconBotton(),
                    Spacer(),
                    IconButtonGoMyLocation(),
                  ],
                ),
              );
            },
          );
        } else if (state is GetLoctionError) {
          return const Scaffold(
            body: Center(
              child: Text('An error occurred'),
            ),
          );
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
