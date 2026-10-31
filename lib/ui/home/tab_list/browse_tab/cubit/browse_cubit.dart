import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/cubit/browse_states.dart';

class BrowseCubit extends Cubit<BrowseStates> {
  BrowseCubit() : super(BrowseInitialState());

  List<Movie> browseResults = [];
  String currentGenre = 'Action';
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;
  static const int pageSize = 20;

  final List<String> allGenres = [
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

  Future<void> fetchMoviesByGenre(String genre) async {
    currentGenre = genre;
    currentPage = 1;
    hasMore = true;
    isLoadingMore = false;
    browseResults.clear();

    emit(BrowseLoadingState());

    try {
      final movies = await DioManager.getMovies(
        genre: currentGenre,
        page: currentPage,
        limit: pageSize,
      );

      if (currentGenre != genre) return;

      browseResults = List.from(movies);
      hasMore = movies.length >= pageSize;

      if (browseResults.isEmpty) {
        emit(BrowseEmptyState());
      } else {
        emit(BrowseSuccessState(movies: browseResults, hasMore: hasMore));
      }
    } catch (e) {
      if (currentGenre != genre) return;
      emit(BrowseErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    if (isLoadingMore || !hasMore) return;

    isLoadingMore = true;
    emit(BrowseLoadingMoreState(currentMovies: browseResults));

    final nextPage = currentPage + 1;
    final genre = currentGenre;

    try {
      final newMovies = await DioManager.getMovies(
        genre: genre,
        page: nextPage,
        limit: pageSize,
      );

      if (currentGenre != genre) return;

      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        currentPage = nextPage;
        final existingIds = browseResults.map((m) => m.id).toSet();
        final uniqueNewMovies = newMovies
            .where((m) => !existingIds.contains(m.id))
            .toList();
        browseResults.addAll(uniqueNewMovies);
        hasMore = newMovies.length >= pageSize;
      }

      emit(BrowseSuccessState(movies: browseResults, hasMore: hasMore));
    } catch (_) {
      if (currentGenre == genre) {
        emit(BrowseSuccessState(movies: browseResults, hasMore: hasMore));
      }
    } finally {
      isLoadingMore = false;
    }
  }
}