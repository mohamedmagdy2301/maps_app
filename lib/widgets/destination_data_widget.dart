import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openstreetmap/core/determine_position.dart';

class DestinationDataWidget extends StatelessWidget {
  const DestinationDataWidget({
    super.key,
    required this.destinationName,
    required this.distanceRoute,
    required this.durationRoute,
    this.onPressedClear,
  });

  final String destinationName;
  final double distanceRoute, durationRoute;
  final Function()? onPressedClear;

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Spacer(),
                Text(
                  destinationName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onPressedClear,
                  icon: const Icon(
                    CupertinoIcons.clear,
                    size: 27,
                  ),
                ),
              ],
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
