import 'package:movies_app/api/model/movie_details.dart';

sealed class MovieDetailsState {}

class MovieDetailsLoading extends MovieDetailsState {}

class MovieDetailsError extends MovieDetailsState {
  final String message;

  MovieDetailsError(this.message);
}

class MovieDetailsSuccess extends MovieDetailsState {
  final MovieDetails movie;
  final bool isInWatchlist;

  final String? message;

  MovieDetailsSuccess({
    required this.movie,
    this.isInWatchlist = false,
    this.message,
  });

  MovieDetailsSuccess copyWith({bool? isInWatchlist, String? message}) {
    return MovieDetailsSuccess(
      movie: movie,
      isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      message: message,
    );
  }
}
