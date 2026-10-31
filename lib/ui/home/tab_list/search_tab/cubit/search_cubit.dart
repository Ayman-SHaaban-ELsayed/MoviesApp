import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/cubit/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  SearchCubit() : super(SearchInitialState());

  List<Movie> searchResults = [];
  String currentQuery = '';
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;
  static const int pageSize = 20;

  Future<void> searchMovies(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      clearSearch();
      return;
    }

    currentQuery = trimmedQuery;
    currentPage = 1;
    hasMore = true;
    isLoadingMore = false;
    searchResults.clear();

    emit(SearchLoadingState());

    try {
      final movies = await DioManager.searchMovies(
        trimmedQuery,
        page: currentPage,
        limit: pageSize,
      );

      // Prevent race conditions
      if (currentQuery != trimmedQuery) return;

      searchResults = List.from(movies);
      hasMore = movies.length >= pageSize;

      if (searchResults.isEmpty) {
        emit(SearchEmptyState(query: trimmedQuery));
      } else {
        emit(SearchSuccessState(movies: searchResults, hasMore: hasMore));
      }
    } catch (e) {
      if (currentQuery != trimmedQuery) return;
      emit(SearchErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> loadMoreMovies() async {
    if (isLoadingMore || !hasMore || currentQuery.isEmpty) return;

    isLoadingMore = true;
    emit(SearchLoadingMoreState(currentMovies: searchResults));

    final nextPage = currentPage + 1;
    final query = currentQuery;

    try {
      final newMovies = await DioManager.searchMovies(
        query,
        page: nextPage,
        limit: pageSize,
      );

      if (currentQuery != query) return;

      if (newMovies.isEmpty) {
        hasMore = false;
      } else {
        currentPage = nextPage;
        // Avoid duplicate movies if any
        final existingIds = searchResults.map((m) => m.id).toSet();
        final uniqueNewMovies =
            newMovies.where((m) => !existingIds.contains(m.id)).toList();
        searchResults.addAll(uniqueNewMovies);
        hasMore = newMovies.length >= pageSize;
      }

      emit(SearchSuccessState(movies: searchResults, hasMore: hasMore));
    } catch (_) {
      if (currentQuery == query) {
        emit(SearchSuccessState(movies: searchResults, hasMore: hasMore));
      }
    } finally {
      isLoadingMore = false;
    }
  }

  void clearSearch() {
    searchResults.clear();
    currentQuery = '';
    currentPage = 1;
    hasMore = true;
    isLoadingMore = false;
    emit(SearchInitialState());
  }
}
