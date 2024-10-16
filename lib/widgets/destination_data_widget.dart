import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  viewDuration(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text(
                  viewDistance(),
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

  viewDistance() {
    if (distanceRoute > 1000) {
      return 'المسافة: ${(distanceRoute / 1000).toStringAsFixed(1)} كم';
    }
    return 'المسافة: ${(distanceRoute).toStringAsFixed(0)} متر';
  }

  viewDuration() {
    if (durationRoute > 60) {
      if (durationRoute > 3600) {
        return 'المدة: ${(durationRoute / 3600).toStringAsFixed(1)} ساعة';
      }
      return 'المدة: ${(durationRoute / 60).toStringAsFixed(1)} دقيقة';
    }
    return 'المدة: ${(durationRoute).toStringAsFixed(0)} ثانية';
  }
}
