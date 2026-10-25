import 'package:flutter/material.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/movie_details/movie_details_screen.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class SimilarMoviesSection extends StatefulWidget {
  final int movieId;

  const SimilarMoviesSection({super.key, required this.movieId});

  @override
  State<SimilarMoviesSection> createState() => _SimilarMoviesSectionState();
}

class _SimilarMoviesSectionState extends State<SimilarMoviesSection> {
  late Future<List<Movie>> _similarMoviesFuture;

  @override
  void initState() {
    super.initState();
    _similarMoviesFuture = DioManager.getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppLocalizations.of(context)!.similar,
              style: AppStyles.bold24White,
            ),
          ),
          SizedBox(height: height * 0.02),
          FutureBuilder<List<Movie>>(
            future: _similarMoviesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: height * 0.18,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.yellow),
                  ),
                );
              }
              if (snapshot.hasError) {
                return Text(
                  AppLocalizations.of(context)!.failedToLoadSimilarMovies,
                  style: AppStyles.regular16White,
                );
              }
              final movies = snapshot.data ?? [];
              if (movies.isEmpty) {
                return Text(
                  AppLocalizations.of(context)!.noSimilarMovies,
                  style: AppStyles.regular16White,
                );
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: movies.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: width * 0.03,
                  mainAxisSpacing: height * 0.02,
                  childAspectRatio: 0.66,
                ),
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MovieDetailsScreen(movieId: movie.id),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(width * 0.035),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  movie.mediumCoverImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.darkGrey,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.white,
                                        size: width * 0.1,
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  top: height * 0.01,
                                  left: width * 0.02,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.02,
                                      vertical: height * 0.006,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: 0.75,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        width * 0.02,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: AppColors.yellow,
                                          size: width * 0.04,
                                        ),
                                        SizedBox(width: width * 0.01),
                                        Text(
                                          movie.rating.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStyles.regular16White,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: height * 0.015),
        ],
      ),
    );
  }
}
