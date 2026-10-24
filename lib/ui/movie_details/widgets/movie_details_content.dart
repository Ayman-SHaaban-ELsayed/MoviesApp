import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/ui/movie_details/cubit/movie_details_cubit.dart';
import 'package:movies_app/ui/movie_details/web_view_screen.dart';
import 'package:movies_app/ui/movie_details/widgets/similar_movies_section.dart';
import 'package:movies_app/utils/size_utils.dart';

import 'movie_background.dart';
import 'movie_play_button.dart';
import 'movie_stats_row.dart';
import 'movie_title_section.dart';
import 'movie_top_bar.dart';
import 'screenshots_section.dart';
import 'summary_section.dart';
import 'watch_button.dart';

class MovieDetailsContent extends StatelessWidget {
  final MovieDetails movie;
  final bool isInWatchlist;
  final int movieId;

  const MovieDetailsContent({
    super.key,
    required this.movie,
    required this.isInWatchlist,
    required this.movieId,
  });

  void _onWatchPressed(BuildContext context) {
    context.read<MovieDetailsCubit>().addToHistory();
    if (movie.url.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WebViewScreen(url: movie.url, title: movie.title),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final cubit = context.read<MovieDetailsCubit>();

    return Stack(
      children: [
        MovieBackground(imageUrl: movie.largeCoverImage),
        SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                MovieTopBar(
                  isInWatchlist: isInWatchlist,
                  onWatchlistTap: cubit.toggleWatchlist,
                ),
                SizedBox(height: height * 0.15),
                MoviePlayButton(onTap: cubit.addToHistory),
                SizedBox(height: height * 0.04),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    children: [
                      MovieTitleSection(title: movie.title, year: movie.year),
                      SizedBox(height: height * 0.03),
                      WatchButton(onPressed: () => _onWatchPressed(context)),
                      SizedBox(height: height * 0.03),
                      MovieStatsRow(movie: movie),
                      SizedBox(height: height * 0.04),
                      ScreenshotsSection(screenshots: movie.screenshots),
                      SizedBox(height: height * 0.05),
                    ],
                  ),
                ),
                SimilarMoviesSection(movieId: movieId),
                SummarySection(summary: movie.summary),
                SizedBox(height: height * 0.015),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
