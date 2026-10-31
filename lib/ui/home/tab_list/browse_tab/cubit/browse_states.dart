import 'package:movies_app/api/model/movie/movie.dart';

abstract class BrowseStates {}

class BrowseInitialState extends BrowseStates {}

class BrowseLoadingState extends BrowseStates {}

class BrowseSuccessState extends BrowseStates {
  final List<Movie> movies;
  final bool hasMore;

  BrowseSuccessState({
    required this.movies,
    this.hasMore = true,
  });
}

class BrowseLoadingMoreState extends BrowseStates {
  final List<Movie> currentMovies;

  BrowseLoadingMoreState({required this.currentMovies});
}

class BrowseEmptyState extends BrowseStates {}

class BrowseErrorState extends BrowseStates {
  final String errorMessage;

  BrowseErrorState({required this.errorMessage});
}