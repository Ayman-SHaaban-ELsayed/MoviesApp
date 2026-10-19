import 'package:movies_app/model/my_user.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileLoadedState extends ProfileState {
  final MyUser user;
  final int watchListCount;
  final int historyCount;
  final List<MovieItemUiModel> watchListMovies;
  final List<MovieItemUiModel> historyMovies;

  ProfileLoadedState({
    required this.user,
    this.watchListCount = 0,
    this.historyCount = 0,
    this.watchListMovies = const [],
    this.historyMovies = const [],
  });

  ProfileLoadedState copyWith({
    MyUser? user,
    int? watchListCount,
    int? historyCount,
    List<MovieItemUiModel>? watchListMovies,
    List<MovieItemUiModel>? historyMovies,
  }) {
    return ProfileLoadedState(
      user: user ?? this.user,
      watchListCount: watchListCount ?? this.watchListCount,
      historyCount: historyCount ?? this.historyCount,
      watchListMovies: watchListMovies ?? this.watchListMovies,
      historyMovies: historyMovies ?? this.historyMovies,
    );
  }
}

class ProfileUpdatingState extends ProfileState {}

class ProfileUpdatedSuccessState extends ProfileState {
  final MyUser user;

  ProfileUpdatedSuccessState({required this.user});
}

class ProfileErrorState extends ProfileState {
  final String errorMessage;

  ProfileErrorState({required this.errorMessage});
}

class ProfileLogoutSuccessState extends ProfileState {}

class ProfileDeleteSuccessState extends ProfileState {}

class MovieItemUiModel {
  final String id;
  final String title;
  final String rating;
  final String imagePath;
  final String year;

  const MovieItemUiModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.imagePath,
    required this.year,
  });
}
