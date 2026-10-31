import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/cubit/browse_cubit.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/cubit/browse_states.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/widgets/movie_card.dart';
import 'package:movies_app/ui/movie_details/movie_details_screen.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BrowseCubit()..fetchMoviesByGenre('Action'),
      child: const _BrowseTabContent(),
    );
  }
}

class _BrowseTabContent extends StatefulWidget {
  const _BrowseTabContent();

  @override
  State<_BrowseTabContent> createState() => _BrowseTabContentState();
}

class _BrowseTabContentState extends State<_BrowseTabContent> {
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

    return SafeArea(
      child: Column(
        children: [
          SizedBox(
            height: height * 0.08,
            child: BlocBuilder<BrowseCubit, BrowseStates>(
              builder: (context, state) {
                final cubit = context.read<BrowseCubit>();
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: cubit.allGenres.length,
                  separatorBuilder: (context, index) => SizedBox(width: width * 0.02),
                  itemBuilder: (context, index) {
                    final genre = cubit.allGenres[index];
                    final isSelected = genre == cubit.currentGenre;

                    return GestureDetector(
                      onTap: () {
                        if (!isSelected) {
                          cubit.fetchMoviesByGenre(genre);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.yellow : AppColors.transparent,
                          borderRadius: BorderRadius.circular(width * 0.05),
                          border: Border.all(
                            color: AppColors.yellow,
                            width: 1,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          genre,
                          style: isSelected
                              ? AppStyles.bold16Black
                              : AppStyles.regular16Yellow,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          Expanded(
            child: BlocBuilder<BrowseCubit, BrowseStates>(
              builder: (context, state) {
                if (state is BrowseLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  );
                }

                if (state is BrowseErrorState) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(width * 0.04),
                      child: Text(
                        state.errorMessage,
                        style: AppStyles.regular16White,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (state is BrowseEmptyState) {
                  return _buildEmptyState(width);
                }

                if (state is BrowseSuccessState || state is BrowseLoadingMoreState) {
                  final movies = (state is BrowseSuccessState)
                      ? state.movies
                      : (state as BrowseLoadingMoreState).currentMovies;
                  final isLoadingMore = state is BrowseLoadingMoreState;

                  if (movies.isEmpty) {
                    return _buildEmptyState(width);
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
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(width * 0.04),
                            child: const CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          ),
                        );
                      }

                      final movie = movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movieId: movie.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return _buildEmptyState(width);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(double width) {
    return Center(
      child: Image.asset(
        AppAssets.emptyLogo,
        width: width * 0.42,
        fit: BoxFit.contain,
      ),
    );
  }
}