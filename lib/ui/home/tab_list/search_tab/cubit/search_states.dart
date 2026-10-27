import 'package:movies_app/api/model/movie/movie.dart';

abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {
  final List<Movie> movies;
  final bool hasMore;

  SearchSuccessState({
    required this.movies,
    this.hasMore = true,
  });
}

class SearchLoadingMoreState extends SearchStates {
  final List<Movie> currentMovies;

  SearchLoadingMoreState({required this.currentMovies});
}

class SearchEmptyState extends SearchStates {
  final String query;

  SearchEmptyState({this.query = ''});
}

class SearchErrorState extends SearchStates {
  final String errorMessage;

  SearchErrorState({required this.errorMessage});
}
