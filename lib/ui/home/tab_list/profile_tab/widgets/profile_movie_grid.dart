import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/ui/movie_details/movie_details_screen.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class ProfileMovieGrid extends StatelessWidget {
  final List<MovieItemUiModel> movies;

  const ProfileMovieGrid({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.68,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            final int? movieId = int.tryParse(movie.id);
            if (movieId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movieId: movieId),
                ),
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildMovieImage(movie.imagePath),
                // Rating Badge
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.75),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.yellow,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          movie.rating,
                          style: AppStyles.bold14Yellow.copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMovieImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.darkGrey,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.yellow,
                strokeWidth: 2,
              ),
            ),
          ),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.darkGrey,
          child: const Icon(Icons.movie, color: AppColors.lightGrey),
        ),
      );
    }

    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.darkGrey,
        child: const Icon(Icons.movie, color: AppColors.lightGrey),
      ),
    );
  }
}

