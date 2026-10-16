import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/home_states.dart';

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

  static int _genreIndex = 0;

  void getHomeData() async {
    emit(HomeLoading());
    try {
      final latestFuture = DioManager.getMovies(
        limit: 10,
        sortBy: 'date_added',
      );

      String currentGenre = _allGenres[_genreIndex % _allGenres.length];
      _genreIndex++;

      final genreFuture = DioManager.getMovies(genre: currentGenre, limit: 10);

      final results = await Future.wait([latestFuture, genreFuture]);

      final latestMovies = results[0];
      final dynamicCategory = MovieCategory(
        categoryName: currentGenre,
        movies: results[1],
      );

      emit(
        HomeSuccess(
          latestMovies: latestMovies,
          dynamicCategory: dynamicCategory,
        ),
      );
    } catch (e) {
      emit(HomeError(errorMessage: e.toString()));
    }
  }
}
