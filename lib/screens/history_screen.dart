import 'package:flutter/material.dart';
import 'package:openstreetmap/core/determine_position.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  static const String routeName = "/history";

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final historyMarkers = ModalRoute.of(context)!.settings.arguments as List;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                historyMarkers.clear();
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: historyMarkers.isEmpty
          ? const Center(
              child: Text(
                'No History',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            )
          : ListView.builder(
              itemCount: historyMarkers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      const Divider(
                        color: Colors.black,
                        thickness: .5,
                        height: 15,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
