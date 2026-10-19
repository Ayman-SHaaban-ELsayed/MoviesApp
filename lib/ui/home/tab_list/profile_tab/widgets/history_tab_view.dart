import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_cubit.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/profile_empty_state.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/profile_movie_grid.dart';

class HistoryTabView extends StatelessWidget {
  final ProfileCubit cubit;

  const HistoryTabView({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    if (cubit.historyMovies.isEmpty) {
      return ProfileEmptyState();
    }

    return ProfileMovieGrid(movies: cubit.historyMovies);
  }
}
