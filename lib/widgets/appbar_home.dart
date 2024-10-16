import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openstreetmap/screens/search_screen.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({super.key, this.onPressedClear, this.onPressedHistory});
  final Function()? onPressedClear;

  final Function()? onPressedHistory;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(
          onPressed: onPressedHistory,
          icon: const Icon(
            Icons.history,
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
          icon: const Icon(
            CupertinoIcons.search,
          ),
        ),
        IconButton(
          onPressed: onPressedClear,
          icon: const Icon(
            CupertinoIcons.clear,
          ),
        ),
        const Spacer(),
        const Text(
          'الخريطة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(width: 5),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
