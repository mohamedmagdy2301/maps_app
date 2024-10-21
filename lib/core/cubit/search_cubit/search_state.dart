part of 'search_cubit.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchSuccess extends SearchState {}

class SearchSuggestions extends SearchState {
  final List<dynamic> suggestions;

  SearchSuggestions({required this.suggestions});
}

class SearchFailure extends SearchState {
  final String message;

  SearchFailure(this.message);
}
