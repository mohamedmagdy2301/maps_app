import 'package:flutter/material.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/determine_position.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';

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
        title: const Text('السجل'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                historyMarkers.clear();
                SharedPreferencesManager.removeData(key: historyKey);
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: historyMarkers.isEmpty
          ? const Center(
              child: Text(
                'لا توجد سجلات',
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
                  child: Card(
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
                  ),
                );
              },
            ),
    );
  }
}
