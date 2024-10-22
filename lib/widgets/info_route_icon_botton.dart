import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/widgets/destination_data_widget.dart';

class InfoRouteIconBotton extends StatelessWidget {
  const InfoRouteIconBotton({super.key});

  @override
  Widget build(BuildContext context) {
    var routeCubit = context.read<RouteCubit>();
    return FloatingActionButton(
      heroTag: 'btn1',
      backgroundColor: Colors.white,
      onPressed: () {
        infoRouteDialog(context, routeCubit);
      },
      child: const Icon(
        Icons.location_on,
        color: Colors.red,
        size: 40,
      ),
    );
  }

  Future<dynamic> infoRouteDialog(BuildContext context, RouteCubit routeCubit) {
    return showAdaptiveDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("اختر الموقع"),
            ],
          ),
          alignment: Alignment.center,
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                routeCubit.clearRoute(
                  context,
                  context.read<GetLoctionCubit>(),
                  context.read<GetLoctionCubit>().markers,
                );
              },
              child: const Text("مسح المسار"),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("رجوع")),
          ],
          content: DestinationDataWidget(
            destinationName: routeCubit.destinationName,
            distanceRoute: routeCubit.distance,
            durationRoute: routeCubit.duration,
          ),
        );
      },
    );
  }
}
