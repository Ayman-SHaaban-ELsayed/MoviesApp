import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../cubit/profile_cubit.dart';
import 'profile_empty_state.dart';
import 'profile_movie_grid.dart';

class WatchListTabView extends StatelessWidget {
  final ProfileCubit cubit;

  const WatchListTabView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    if (cubit.watchListMovies.isEmpty) {
      return ProfileEmptyState();
    }

    return ProfileMovieGrid(movies: cubit.watchListMovies);
  }
}
