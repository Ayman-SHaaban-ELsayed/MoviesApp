import 'package:flutter/material.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class MovieCard extends StatelessWidget {
  final MovieItemUiModel movie;
  final VoidCallback? onTap;

  const MovieCard({super.key, required this.movie, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // صورة البوستر
            Image.network(
              movie.imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.darkGrey,
                child: const Icon(Icons.movie, color: AppColors.grey, size: 50),
              ),
            ),

            // تدرج لوني في الأسفل عشان يوضح النص
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80, // كبرت الارتفاع شوية عشان النص
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.transparent, Colors.black87],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            // اسم الفيلم (اللي كان ناقص)
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                movie.title,
                style: AppStyles.regular14White.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // تقييم الفيلم (النجمة)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.yellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      movie.rating,
                      style: AppStyles.regular14White.copyWith(
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
    );
  }
}