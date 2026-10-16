import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/cubit_home_view_model.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/cubit/home_states.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_card.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_gradient.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/section_header.dart';
import 'package:movies_app/utils/app_assets.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';
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
    final height = context.height;
    final width = context.width;
    return BlocProvider(
      create: (context) => CubitHomeViewModel()..getHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<CubitHomeViewModel, HomeStates>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: AppColors.yellow),
                    SizedBox(height: height * 0.02),
                    Text(
                      AppLocalizations.of(context)!.loading,
                      style: AppStyles.regular16White,
                    ),
                  ],
                ),
              );
            } else if (state is HomeError) {
              return Center(
                child: Text(
                  AppLocalizations.of(context)!.failedToLoadMovies,
                  style: AppStyles.regular16White,
                ),
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
                      height: height * 0.65,
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
                        SizedBox(height: height * 0.03),
                        Image.asset(
                          AppAssets.availableNow,
                          fit: BoxFit.fill,
                          height: height * 0.09,
                        ),
                        SizedBox(height: height * 0.03),

                        CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            autoPlay: true,
                            viewportFraction: 0.55,
                            height: height * 0.38,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentCarouselIndex = index;
                              });
                            },
                          ),
                          items: state.latestMovies.map((movie) {
                            return MovieCard(
                              imagePath: movie.mediumCoverImage,
                              rating: movie.rating.toDouble(),
                              onTap: () {
                                //todo
                                print('Clicked Carousel Movie: ${movie.title}');
                              },
                            );
                          }).toList(),
                        ),

                        SizedBox(height: height * 0.04),
                        Image.asset(
                          AppAssets.watchNow,
                          fit: BoxFit.fill,
                          height: height * 0.15,
                        ),
                        SizedBox(height: height * 0.02),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionHeader(
                              title: state.dynamicCategory.categoryName,
                              seeMoreText: AppLocalizations.of(context)!
                                  .seeMore,
                              onSeeMoreTap: () {
                                //todo
                                print(
                                  'See More ${state.dynamicCategory.categoryName}',
                                );
                              },
                            ),
                            SizedBox(height: height * 0.03),
                            SizedBox(
                              height: height * 0.34,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.04,
                                ),
                                scrollDirection: Axis.horizontal,
                                itemCount: state.dynamicCategory.movies.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: width * 0.03),
                                itemBuilder: (context, index) {
                                  final movie =
                                      state.dynamicCategory.movies[index];
                                  return MovieCard(
                                    imagePath: movie.mediumCoverImage,
                                    rating: movie.rating.toDouble(),
                                    onTap: () {
                                      //todo
                                      print('Clicked: ${movie.title}');
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: height * 0.15),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
