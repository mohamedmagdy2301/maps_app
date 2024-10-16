import 'package:flutter/material.dart';

class NoThereHistoryMarkers extends StatelessWidget {
  const NoThereHistoryMarkers({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 100,
            color: Colors.grey,
          ),
          SizedBox(height: 10),
          Text(
            'لا توجد سجلات',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
