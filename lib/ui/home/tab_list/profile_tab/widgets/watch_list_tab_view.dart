import 'package:flutter/material.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_cubit.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/profile_empty_state.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/profile_movie_grid.dart';

class WatchListTabView extends StatelessWidget {
  final ProfileCubit cubit;

  const WatchListTabView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    if (cubit.watchListMovies.isEmpty) {
      return ProfileEmptyState();
    }

    return ProfileMovieGrid(movies: cubit.watchListMovies);
  }
}
