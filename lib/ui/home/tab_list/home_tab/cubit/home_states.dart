import 'package:movies_app/api/model/movie/movie.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}
class HomeLoading extends HomeStates {}

class MovieCategory {
  final String categoryName;
  final List<Movie> movies;
  MovieCategory({required this.categoryName, required this.movies});
}

class HomeSuccess extends HomeStates {
  final List<Movie> latestMovies;
  final MovieCategory dynamicCategory;

  HomeSuccess({required this.latestMovies, required this.dynamicCategory});
}

class HomeError extends HomeStates {
  final String errorMessage;
  HomeError({required this.errorMessage});
}