import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';
import 'package:openstreetmap/screens/history_screen.dart';
import 'package:openstreetmap/widgets/appbar_home.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController mapController = MapController();
  List<LatLng> routePoints = [];
  List<List<dynamic>> historyMarkers =
      SharedPreferencesManager.getData(key: historyKey) ?? [];
  List<dynamic> coords = [];
  double durationRoute = 0;
  double distanceRoute = 0;
  String destinationName = "";

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    return BlocBuilder<GetLoctionCubit, GetLoctionState>(
      builder: (context, state) {
        if (state is GetLoctionSuccess) {
          return BlocProvider(
            create: (_) => RouteCubit(),
            child: Scaffold(
              appBar: AppBarHome(
                onPressedHistory: () {
                  Navigator.pushNamed(
                    context,
                    HistoryScreen.routeName,
                    arguments: historyMarkers,
                  );
                },
              ),
              body: BlocConsumer<RouteCubit, RouteState>(
                listener: (context, state) {
                  if (state is RouteLoaded) {
                    setState(() {
                      routePoints = state.routePoints;
                      durationRoute = state.duration;
                      distanceRoute = state.distance;
                      destinationName = state.destinationName;
                      historyMarkers.add([
                        state.destinationName,
                        state.duration,
                        state.distance
                      ]);

                      SharedPreferencesManager.setData(
                        key: historyKey,
                        value: historyMarkers,
                      );

                      getLoctionCubit.markers.add(
                        Marker(
                          point: state.routePoints.last,
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      );
                    });
                  } else if (state is RouteError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  return getLoctionCubit.currentLocation == null
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            Expanded(
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(
                                    getLoctionCubit.currentLocation!.latitude,
                                    getLoctionCubit.currentLocation!.longitude,
                                  ),
                                  initialZoom: 16,
                                  keepAlive: true,
                                  onTap: (tapPosition, point) async {
                                    context.read<RouteCubit>().getRouteFromApi(
                                          LatLng(
                                              getLoctionCubit
                                                  .currentLocation!.latitude,
                                              getLoctionCubit
                                                  .currentLocation!.longitude),
                                          point,
                                        );
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate: urlTemplate,
                                    subdomains: const ['a', 'b', 'c'],
                                  ),
                                  MarkerLayer(
                                    markers: getLoctionCubit.markers,
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
                        );
                },
              ),
            ),
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
