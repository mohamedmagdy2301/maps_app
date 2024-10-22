import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';

class MakeDiractionIconButton extends StatelessWidget {
  const MakeDiractionIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    var getLoctionCubit = context.read<GetLoctionCubit>();
    var markers = context.read<GetLoctionCubit>().markers;

    var routeCubit = context.read<RouteCubit>();
    return FloatingActionButton(
      heroTag: 'btn2',
      backgroundColor: Colors.white,
      onPressed: () async {
        await routeCubit.getDiractionesRouteFromApi(
          context,
          getLoctionCubit.currentLocation!,
          routeCubit.pointDestination!,
          markers,
          getLoctionCubit.mapController,
        );
      },
      child: const Icon(
        Icons.directions,
        color: Colors.red,
        size: 40,
      ),
    );
  }
}
