import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/cubit_home_view_model.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/home_states.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/error_widget.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/latest_movies_carousel.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/loading_widget.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_gradient.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_list_widget.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/section_header.dart';
import 'package:movies_app/utils/app_assets.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/size_utils.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = context.height;
    return BlocProvider(
      create: (context) => CubitHomeViewModel()..getHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<CubitHomeViewModel, HomeStates>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return LoadingWidget();
            } else if (state is HomeError) {
              return AppErrorWidget(
                onRetry: () {
                  context.read<CubitHomeViewModel>().getHomeData();
                },
              );
            } else if (state is HomeSuccess) {
              String currentBgImage = state.latestMovies.isNotEmpty
                  ? state.latestMovies[_currentCarouselIndex].mediumCoverImage
                  : '';
              return Stack(
                children: [
                  if (currentBgImage.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: screenHeight * 0.65,
                      child: CachedNetworkImage(
                        imageUrl: currentBgImage,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                  const MovieGradient(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.03),
                        Image.asset(
                          AppAssets.availableNow,
                          fit: BoxFit.fill,
                          height: screenHeight * 0.09,
                        ),
                        SizedBox(height: screenHeight * 0.03),

                        LatestMoviesCarousel(
                          movies: state.latestMovies,
                          imagePath: (movie) => movie.mediumCoverImage,
                          rating: (movie) => movie.rating.toDouble(),
                          title: (movie) => movie.title,
                          height: screenHeight * 0.38,
                          viewportFraction: 0.55,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentCarouselIndex = index;
                            });
                          },
                          onMovieTap: (movie) {
                            print('Clicked: ${movie.title}');
                          },
                        ),

                        SizedBox(height: screenHeight * 0.04),
                        Image.asset(
                          AppAssets.watchNow,
                          fit: BoxFit.fill,
                          height: screenHeight * 0.15,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        SectionHeader(
                          title: state.dynamicCategory.categoryName,
                          seeMoreText: AppLocalizations.of(context)!.seeMore,
                          onSeeMoreTap: () {
                            //todo
                            print(
                              'See More ${state.dynamicCategory.categoryName}',
                            );
                          },
                        ),
                        SizedBox(height: screenHeight * 0.03),
                        MovieListWidget(
                          movies: state.dynamicCategory.movies,
                          height: screenHeight * 0.34,
                          widthCard: 146,
                          heightCard: 220,
                          onMovieTap: (movie) {
                            print('Clicked: ${movie.title}');
                            // TODO: Navigate to movie details.
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
