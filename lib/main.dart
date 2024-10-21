import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/core/cubit/search_cubit/search_cubit.dart';
import 'package:openstreetmap/core/shared_preferences_manager.dart';
import 'package:openstreetmap/screens/history_screen.dart';
import 'package:openstreetmap/screens/home_screen.dart';
import 'package:openstreetmap/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesManager.sharedPreferencesInitialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetLoctionCubit>(
      create: (context) => GetLoctionCubit()..getCurrentLocation(),
      child: BlocProvider<RouteCubit>(
        create: (_) => RouteCubit(),
        child: BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'الخريطة',
            initialRoute: '/',
            routes: {
              '/': (context) => const HomeScreen(),
              SearchScreen.routeName: (context) => const SearchScreen(),
              HistoryScreen.routeName: (context) => const HistoryScreen(),
            },
          ),
        ),
      ),
    );
  }
}
