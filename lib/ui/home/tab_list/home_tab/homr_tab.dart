import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_card.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_gradient.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/section_header.dart';
import 'package:movies_app/utils/app_assets.dart';

import '../../../../utils/app_colors.dart';

class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  List<String> moviesList = [
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
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          Image.asset(AppAssets.moviePosterBackground, fit: BoxFit.fill),
          const MovieGradient(),
          Column(
            children: [
              SizedBox(height: 12.h),
              Image.asset(AppAssets.availableNow, fit: BoxFit.fill),
              SizedBox(height: 65.h),
              CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  autoPlay: true,
                  viewportFraction: .5,
                  height: 277.h,
                ),
                items: moviesList.map((imagePath) {
                  return MovieCard(
                    imagePath: imagePath,
                    rating: 7.7,
                    onTap: () {
                      print('Movie clicked!');
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 34.h),
              Image.asset(AppAssets.watchNow, fit: BoxFit.fill),
              SizedBox(height: 56.h),
              SectionHeader(
                title: 'Action',
                onSeeMoreTap: () {
                  print('See More Action');
                },
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.separated(
                  padding: REdgeInsets.symmetric(horizontal: 16.w),
                  scrollDirection: Axis.horizontal,
                  itemCount: moviesList.length,
                  separatorBuilder: (context, index) => SizedBox(width: 12.w),
                  itemBuilder: (context, index) => MovieCard(
                    imagePath: moviesList[index],
                    rating: 7.7,
                    onTap: () {
                      print('Movie clicked!');
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
