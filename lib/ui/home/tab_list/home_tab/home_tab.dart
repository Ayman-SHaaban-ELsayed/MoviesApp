import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_card.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_gradient.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/section_header.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/size_utils.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../utils/app_colors.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final List<String> moviesList = [
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
    AppAssets.timeIsTheEnemy,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeUtils.getWidth(context: context);
    final screenHeight = SizeUtils.getHeight(context: context);

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Image.asset(AppAssets.moviePosterBackground, fit: BoxFit.fill),
          const MovieGradient(),
          Column(
            children: [
              SizedBox(height: screenHeight * 0.02),

              Image.asset(AppAssets.availableNow, fit: BoxFit.fill),

              SizedBox(height: screenHeight * 0.03),

              CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: 0.5,
                  height: screenHeight * 0.34,
                ),
                items: moviesList.map((imagePath) {
                  return MovieCard(
                    imagePath: imagePath,
                    rating: 7.7,
                    onTap: () {
                      debugPrint('Movie clicked!');
                    },
                  );
                }).toList(),
              ),

              SizedBox(height: screenHeight * 0.03),

              Image.asset(AppAssets.watchNow, fit: BoxFit.fill),

              SizedBox(height: screenHeight * 0.03),

              SectionHeader(
                seeMoreText: AppLocalizations.of(context)!.seeAll,
                title: 'Action',
                onSeeMoreTap: () {
                  debugPrint('See More Action');
                },
              ),

              SizedBox(height: screenHeight * 0.01),

              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.041,
                  ),
                  scrollDirection: Axis.horizontal,
                  itemCount: moviesList.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(width: screenWidth * 0.031);
                  },
                  itemBuilder: (context, index) {
                    return MovieCard(
                      imagePath: moviesList[index],
                      rating: 7.7,
                      onTap: () {
                        debugPrint('Movie clicked!');
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
