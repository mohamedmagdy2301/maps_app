import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:openstreetmap/screens/search_screen.dart';

class AppBarHome extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHome({super.key, this.onPressedHistory});

  final Function()? onPressedHistory;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text(
        'الخريطة',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
      leading: IconButton(
        onPressed: onPressedHistory,
        icon: const Icon(
          Icons.history,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, SearchScreen.routeName);
          },
          icon: const Icon(
            CupertinoIcons.search,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
