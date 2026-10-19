import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/home_states.dart';

import '../../../../../api/model/movie/movie.dart';

class CubitHomeViewModel extends Cubit<HomeStates> {
  CubitHomeViewModel() : super(HomeInitial());

  static const List<String> _allGenres = [
    'Action',
    'Comedy',
    'Sci-Fi',
    'Romance',
    'Horror',
    'Thriller',
    'Animation',
    'Drama',
    'Adventure',
  ];
  static int _currentGenreStartIndex = 0;
  void getHomeData() async {
    emit(HomeLoading());
    try {
      final latestFuture = DioManager.getMovies(
        limit: 10,
        sortBy: 'date_added',
      );

      final selectedGenres = List.generate(3, (index) =>
            _allGenres[(_currentGenreStartIndex + index) % _allGenres.length],);

      _currentGenreStartIndex = (_currentGenreStartIndex + 3) % _allGenres.length;

      final categoriesFuture = Future.wait(
        selectedGenres.map((genre) async {
          final movies = await DioManager.getMovies(genre: genre, limit: 10);

          return MovieCategory(categoryName: genre, movies: movies);
        }),
      );

      final results = await Future.wait([latestFuture, categoriesFuture]);

      final latestMovies = results[0] as List<Movie>;
      final categories = results[1] as List<MovieCategory>;
      emit(HomeSuccess(latestMovies: latestMovies, categories: categories));
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }
}
