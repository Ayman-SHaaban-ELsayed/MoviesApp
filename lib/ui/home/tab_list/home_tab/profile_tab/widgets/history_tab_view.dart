import 'package:flutter/material.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../profile_cubit.dart';
import 'profile_empty_state.dart';
import 'profile_movie_grid.dart';

class HistoryTabView extends StatelessWidget {
  final ProfileCubit cubit;

  const HistoryTabView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    if (cubit.historyMovies.isEmpty) {
      return ProfileEmptyState(
        title: locale.emptyHistory,
        hint: locale.emptyHistoryHint,
      );
    }

    return ProfileMovieGrid(movies: cubit.historyMovies);
  }
}
