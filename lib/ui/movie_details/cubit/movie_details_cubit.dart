import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/fireStore/firebase_utils.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';

import 'movie_details_state.dart';

class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  final int movieId;

  MovieDetailsCubit(this.movieId) : super(MovieDetailsLoading());

  String? get _userId {
    final id = FirebaseAuth.instance.currentUser?.uid ?? SharedPrefUtils.userId;
    if (id == null || id.isEmpty || id == 'preview_user') return null;
    return id;
  }

  MovieItemUiModel _toItem(MovieDetails movie) => MovieItemUiModel(
    id: movie.id.toString(),
    title: movie.title,
    rating: movie.rating.toString(),
    imagePath: movie.largeCoverImage,
    year: movie.year.toString(),
  );

  Future<void> loadMovie() async {
    emit(MovieDetailsLoading());
    try {
      final movie = await DioManager.getMovieDetails(movieId);
      emit(MovieDetailsSuccess(movie: movie));
      await _checkWatchlistStatus();
    } catch (e) {
      emit(MovieDetailsError(e.toString()));
    }
  }

  Future<void> _checkWatchlistStatus() async {
    final userId = _userId;
    if (userId == null) return;

    try {
      final inList = await FirebaseUtils.isMovieInWatchlist(
        userId,
        movieId.toString(),
      );
      final current = state;
      if (!isClosed && current is MovieDetailsSuccess) {
        emit(current.copyWith(isInWatchlist: inList));
      }
    } catch (_) {}
  }

  Future<void> toggleWatchlist() async {
    final current = state;
    if (current is! MovieDetailsSuccess) return;

    final userId = _userId;
    if (userId == null) {
      emit(current.copyWith(message: 'Please login first'));
      return;
    }

    final movie = current.movie;
    try {
      if (current.isInWatchlist) {
        await FirebaseUtils.removeFromWatchlist(userId, movie.id.toString());
        emit(
          current.copyWith(
            isInWatchlist: false,
            message: 'Removed from Watch List',
          ),
        );
      } else {
        await FirebaseUtils.addToWatchlist(userId, _toItem(movie));
        emit(
          current.copyWith(isInWatchlist: true, message: 'Added to Watch List'),
        );
      }
    } catch (e) {
      emit(current.copyWith(message: 'Error: $e'));
    }
  }

  Future<void> addToHistory() async {
    final current = state;
    final userId = _userId;
    if (current is! MovieDetailsSuccess || userId == null) return;

    try {
      await FirebaseUtils.addToHistory(userId, _toItem(current.movie));
    } catch (_) {}
  }
}
