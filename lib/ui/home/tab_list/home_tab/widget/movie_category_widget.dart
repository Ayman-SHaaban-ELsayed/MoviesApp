import 'package:flutter/material.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_list_widget.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/section_header.dart';

class MovieCategoryWidget extends StatelessWidget {
  final String categoryName;
  final List<Movie> movies;
  final double height;
  final double widthCard;
  final double heightCard;
  final ValueChanged<Movie>? onMovieTap;
  final VoidCallback? onSeeMoreTap;

  const MovieCategoryWidget({
    super.key,
    required this.categoryName,
    required this.movies,
    required this.height,
    this.widthCard = 146,
    this.heightCard = 220,
    this.onMovieTap,
    this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: categoryName,
          seeMoreText: AppLocalizations.of(context)!.seeMore,
          onSeeMoreTap: onSeeMoreTap ?? () {},
        ),
        SizedBox(height: screenHeight * 0.02),
        MovieListWidget(
          movies: movies,
          height: height,
          widthCard: widthCard,
          heightCard: heightCard,
          onMovieTap: onMovieTap,
        ),
      ],
    );
  }
}
