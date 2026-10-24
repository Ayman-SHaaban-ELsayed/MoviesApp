import 'package:flutter/material.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/api/model/movie/movie.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/movie_details/similar_movies_section.dart';
import 'package:movies_app/ui/widgets/elevated_button_reuse.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetails> _movieDetailsFuture;
  late Future<List<Movie>> _similarMoviesFuture;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = DioManager.getMovieDetails(widget.movieId);
    _similarMoviesFuture = DioManager.getSimilarMovies(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder<MovieDetails>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading movie', style: AppStyles.regular16White),
            );
          }

          final movie = snapshot.data!;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  movie.largeCoverImage,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.yellow),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.broken_image, color: AppColors.white, size: 50),
                  ),
                ),
              ),

              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.6),
                        AppColors.primary,
                        AppColors.primary,
                      ],
                      stops: const [0.0, 0.4, 0.75, 1.0],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.01,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            IconButton(
                              icon: Image.asset(
                                AppAssets.watchListIcon,
                                color: AppColors.white,
                                width: 24,
                                height: 24,
                              ),
                              onPressed: () {
                                // إضافة للـ Watchlist
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.25),

                      GestureDetector(
                        onTap: () {
                        },
                        child: Image.asset(
                          AppAssets.playMovie,
                          width: 100,
                          height: 100,
                        ),
                      ),

                      SizedBox(height: height * 0.05),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          children: [
                            Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: AppStyles.bold24White,
                            ),
                            SizedBox(height: height * 0.01),
                            Text(
                              '${movie.year}',
                              style: AppStyles.regular16White.copyWith(
                                color: AppColors.lightGrey,
                              ),
                            ),
                            SizedBox(height: height * 0.03),

                            ElevatedButtonReuse(
                              background: AppColors.red,
                              onpressed: () {},
                              ChildType: Text(
                                'Watch',
                                style: AppStyles.bold20White,
                              ),
                            ),
                            SizedBox(height: height * 0.03),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatChip(
                                  iconPath: AppAssets.likeIcon,
                                  text: '${movie.likeCount}',
                                ),
                                _buildStatChip(
                                  iconPath: AppAssets.durationIcon,
                                  text: '${movie.runtime}',
                                ),
                                _buildStatChip(
                                  iconPath: AppAssets.starIcon,
                                  text: '${movie.rating}',
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.03),

                            if (movie.screenshots.isNotEmpty) ...[
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  AppLocalizations.of(context)!.screenShots,
                                  style: AppStyles.bold20White,
                                ),
                              ),
                              SizedBox(height: height * 0.015),
                              SizedBox(
                                height: height * 0.15,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: movie.screenshots.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 10,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          movie.screenshots[index],
                                          width: width * 0.4,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: width * 0.4,
                                              color: AppColors.darkGrey,
                                              child: const Icon(
                                                Icons.broken_image,
                                                color: AppColors.white,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: height * 0.03),
                            ],
                          ],
                        ),
                      ),

                      // Hello there <3 its me walid and this's my section don't play with it please , thanks .
                      //Similar Section :
                      SimilarMoviesSection(
                        movieId: widget.movieId,
                      ),
                      //Summary Section :
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          children: [
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                AppLocalizations.of(context)!.summary,
                                style: AppStyles.bold24White,
                              ),
                            ),
                            SizedBox(height: height * 0.015),
                            Align(
                              alignment: AlignmentDirectional.centerStart,
                              child: Text(
                                movie.summary
                                    .trim()
                                    .isEmpty
                                    ? AppLocalizations.of(context)!
                                    .noSummaryAvailable
                                    : movie.summary,
                                style: AppStyles.regular16White,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatChip({
    required String iconPath,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, color: AppColors.yellow, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppStyles.bold16Black.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}