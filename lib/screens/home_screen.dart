import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/widgets/appbar_home.dart';
import 'package:openstreetmap/widgets/flutter_map_builder.dart';
import 'package:openstreetmap/widgets/icon_button_go_my_location.dart';
import 'package:openstreetmap/widgets/info_route_icon_botton.dart';
import 'package:openstreetmap/widgets/make_diraction_icon_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetLoctionCubit, GetLoctionState>(
      builder: (context, state) {
        if (state is GetLoctionSuccess) {
          return BlocBuilder<RouteCubit, RouteState>(
            builder: (context, state) {
              return Scaffold(
                appBar: const AppBarHome(),
                body: state is DirectionRouteLoaded
                    ? FlutterMapBuilder(points: state.routePoints)
                    : const FlutterMapBuilder(points: []),
                floatingActionButton: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    state is DirectionRouteLoaded
                        ? const InfoRouteIconBotton()
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    state is DestinationRouteLoaded ||
                            state is DirectionRouteLoaded
                        ? const MakeDiractionIconButton()
                        : const SizedBox(),
                    const SizedBox(height: 10),
                    const IconButtonGoMyLocation(),
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
