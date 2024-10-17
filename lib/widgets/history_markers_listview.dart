import 'package:flutter/material.dart';
import 'package:openstreetmap/core/determine_position.dart';

class HistoryMarkersListView extends StatelessWidget {
  const HistoryMarkersListView({
    super.key,
    required this.historyMarkers,
  });

  final List historyMarkers;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: historyMarkers.length,
      // ! to keep the markers is last on the screen
      controller: ScrollController(
        keepScrollOffset: true,
        initialScrollOffset: historyMarkers.length * 100,
      ),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الموقع: ${historyMarkers[index][0]}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    viewDuration(historyMarkers[index][1]),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    viewDistance(historyMarkers[index][2]),
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
