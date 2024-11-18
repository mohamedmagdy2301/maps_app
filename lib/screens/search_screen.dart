import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openstreetmap/core/cubit/get_loction/get_loction_cubit.dart';
import 'package:openstreetmap/core/cubit/route/route_cubit.dart';
import 'package:openstreetmap/core/cubit/search_cubit/search_cubit.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  static const String routeName = "/search";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'البحــــث',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: const SearchForm(),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  _SearchFormState createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _controller = TextEditingController();
  List _suggestions = [];

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchCubit, SearchState>(
      listener: (context, state) {
        if (state is SearchSuccess) {
          Navigator.pop(context);
          context.read<RouteCubit>().getDestinationRoute(
                context.read<GetLoctionCubit>().currentLocation!,
                context.read<SearchCubit>().destination!,
                context.read<GetLoctionCubit>().markers,
                context.read<GetLoctionCubit>().mapController,
              );
          log(context.read<SearchCubit>().destination.toString());
        } else if (state is SearchSuggestions) {
          setState(() {
            _suggestions = state.suggestions;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter place name',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      context.read<SearchCubit>().searchPlace(_controller.text);
                    }
                  },
                ),
                prefixIcon: const Icon(Icons.location_on),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  context.read<SearchCubit>().fetchSuggestions(value);
                } else {
                  setState(() {
                    _suggestions = [];
                  });
                }
              },
              onSubmitted: (value) {
                if (_controller.text.isNotEmpty) {
                  log(_controller.text.toString());
                  Navigator.pop(context);
                  context.read<RouteCubit>().getDestinationRoute(
                        context.read<GetLoctionCubit>().currentLocation!,
                        context.read<SearchCubit>().destination!,
                        context.read<GetLoctionCubit>().markers,
                        context.read<GetLoctionCubit>().mapController,
                      );
                }
              },
            ),
            const SizedBox(height: 16.0),
            if (_suggestions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    final displayName = suggestion['display_name'];
                    return ListTile(
                      title: Text(displayName),
                      onTap: () {
                        _controller.text = displayName;
                        setState(() {
                          _suggestions = [];
                        });
                        Navigator.pop(context);
                        context.read<RouteCubit>().getDestinationRoute(
                              context.read<GetLoctionCubit>().currentLocation!,
                              context.read<SearchCubit>().destination!,
                              context.read<GetLoctionCubit>().markers,
                              context.read<GetLoctionCubit>().mapController,
                            );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
