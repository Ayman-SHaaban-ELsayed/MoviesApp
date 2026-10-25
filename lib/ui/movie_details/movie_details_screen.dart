import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/ui/movie_details/cubit/movie_details_cubit.dart';
import 'package:movies_app/ui/movie_details/cubit/movie_details_state.dart';
import 'package:movies_app/ui/movie_details/widgets/movie_details_content.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';


class MovieDetailsScreen extends StatelessWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MovieDetailsCubit(movieId)..loadMovie(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocConsumer<MovieDetailsCubit, MovieDetailsState>(
          listenWhen: (prev, curr) =>
              curr is MovieDetailsSuccess && curr.message != null,
          listener: (context, state) {
            if (state is MovieDetailsSuccess && state.message != null) {
              Fluttertoast.showToast(msg: state.message!);
            }
          },
          builder: (context, state) {
            return switch (state) {
              MovieDetailsLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.yellow),
              ),
              MovieDetailsError() => Center(
                child: Text(
                  'Error loading movie',
                  style: AppStyles.regular16White,
                ),
              ),
              MovieDetailsSuccess() => MovieDetailsContent(
                movie: state.movie,
                isInWatchlist: state.isInWatchlist,
                movieId: movieId,
              ),
            };
          },
        ),
      ),
    );
  }
}