import 'package:flutter/material.dart';
import 'package:openstreetmap/core/contants.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';
import 'package:openstreetmap/widgets/history_markers_listview.dart';
import 'package:openstreetmap/widgets/no_there_history_markers.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  static const String routeName = "/history";

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final List historyMarkers =
        ModalRoute.of(context)!.settings.arguments as List;
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
          ? const NoThereHistoryMarkers()
          : HistoryMarkersListView(historyMarkers: historyMarkers),
    );
  }
}
