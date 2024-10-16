import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openstreetmap/core/determine_position.dart';

class DestinationDataWidget extends StatelessWidget {
  const DestinationDataWidget({
    super.key,
    required this.destinationName,
    required this.distanceRoute,
    required this.durationRoute,
  });

  final String destinationName;
  final double distanceRoute, durationRoute;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: SizedBox(
        height: 80,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              destinationName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  viewDuration(durationRoute),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  viewDistance(distanceRoute),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
