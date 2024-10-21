import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:openstreetmap/core/contants.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());
  LatLng? destination;
  Future<void> searchPlace(String place) async {
    final url = Uri.parse(
        '$sreachApiKey?q=$place&format=json&addressdetails=1&limit=1');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        log(data[0].toString());

        destination =
            LatLng(double.parse(data[0]['lat']), double.parse(data[0]['lon']));

        emit(SearchSuccess());
      } else {
        emit(SearchFailure('No results found for the place.'));
      }
    } else {
      emit(SearchFailure('Failed to search place: ${response.statusCode}'));
    }
  }

  // Future<void> fetchSuggestions(String query) async {
  //   if (query.isEmpty) {
  //     emit(SearchInitial());
  //     return;
  //   }

  //   final url = Uri.parse(
  //       '$sreachApiKey?q=$query&format=json&addressdetails=1&limit=5');

  //   try {
  //     final response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       final List<dynamic> data = jsonDecode(response.body);
  //       emit(SearchSuggestions(suggestions: data));
  //     } else {
  //       emit(SearchFailure(
  //           'Failed to fetch suggestions: ${response.statusCode}'));
  //     }
  //   } catch (e) {
  //     emit(SearchFailure('Error occurred while fetching suggestions: $e'));
  //   }
  // }
}
