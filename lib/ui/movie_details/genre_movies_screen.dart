import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/cubit/browse_cubit.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/cubit/browse_states.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/widgets/movie_card.dart';
import 'package:movies_app/ui/movie_details/movie_details_screen.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class GenreMoviesScreen extends StatelessWidget {
  final String genre;

  const GenreMoviesScreen({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrowseCubit()..fetchMoviesByGenre(genre),
      child: _GenreMoviesContent(genre: genre),
    );
  }
}

class _GenreMoviesContent extends StatefulWidget {
  final String genre;

  const _GenreMoviesContent({required this.genre});

  @override
  State<_GenreMoviesContent> createState() => _GenreMoviesContentState();
}

class _GenreMoviesContentState extends State<_GenreMoviesContent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<BrowseCubit>().loadMoreMovies();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.yellow),
        title: Text(widget.genre, style: AppStyles.regular16White),
        centerTitle: true,
      ),
      body: BlocBuilder<BrowseCubit, BrowseStates>(
        builder: (context, state) {
          if (state is BrowseLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }

          if (state is BrowseErrorState) {
            return Center(
              child: Text(
                state.errorMessage,
                style: AppStyles.regular16White,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is BrowseSuccessState || state is BrowseLoadingMoreState) {
            final movies = (state is BrowseSuccessState)
                ? state.movies
                : (state as BrowseLoadingMoreState).currentMovies;
            final isLoadingMore = state is BrowseLoadingMoreState;

            if (movies.isEmpty) {
              return Center(
                child: Text('No movies found', style: AppStyles.regular16White),
              );
            }

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.04,
                vertical: height * 0.01,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.04,
                mainAxisSpacing: height * 0.02,
                childAspectRatio: 0.65,
              ),
              itemCount: movies.length + (isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == movies.length) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }

                final movie = movies[index];
                return MovieCard(
                  movie: movie,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MovieDetailsScreen(movieId: movie.id),
                      ),
                    );
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
