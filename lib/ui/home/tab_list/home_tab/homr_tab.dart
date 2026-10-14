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
                    imagePath: 'https://www.google.com/imgres?q=%D8%B3%D9%88%D8%B1%D9%87%20%D8%A8%D9%88%D8%B3%D8%AA%D8%B1%20%D9%83%D8%A7%D8%A8%D8%AA%D9%86%20%D8%A7%D9%85%D8%B1%D9%8A%D9%83%D8%A7&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Far%2Farchive%2F7%2F74%2F20250406152742%2521Captain_america_civil_war_ver3.jpg&imgrefurl=https%3A%2F%2Far.wikipedia.org%2Fwiki%2F%25D9%2585%25D9%2584%25D9%2581%3ACaptain_america_civil_war_ver3.jpg&docid=-xj6kRa7KGk-WM&tbnid=giV16T3BEkPZTM&vet=12ahUKEwi5n4LClLqXAxX_ZUEAHb3fAcEQnPAOegQIQRAA..i&w=1382&h=2048&hcb=2&ved=2ahUKEwi5n4LClLqXAxX_ZUEAHb3fAcEQnPAOegQIQRAA',
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
                    imagePath:'https://www.google.com/imgres?q=%D8%B3%D9%88%D8%B1%D9%87%20%D8%A8%D9%88%D8%B3%D8%AA%D8%B1%20%D9%83%D8%A7%D8%A8%D8%AA%D9%86%20%D8%A7%D9%85%D8%B1%D9%8A%D9%83%D8%A7&imgurl=https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Far%2Farchive%2F7%2F74%2F20250406152742%2521Captain_america_civil_war_ver3.jpg&imgrefurl=https%3A%2F%2Far.wikipedia.org%2Fwiki%2F%25D9%2585%25D9%2584%25D9%2581%3ACaptain_america_civil_war_ver3.jpg&docid=-xj6kRa7KGk-WM&tbnid=giV16T3BEkPZTM&vet=12ahUKEwi5n4LClLqXAxX_ZUEAHb3fAcEQnPAOegQIQRAA..i&w=1382&h=2048&hcb=2&ved=2ahUKEwi5n4LClLqXAxX_ZUEAHb3fAcEQnPAOegQIQRAA',
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
