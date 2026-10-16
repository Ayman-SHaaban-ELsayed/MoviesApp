import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';
import '../../../../../utils/size_utils.dart';

class MovieCard extends StatelessWidget {
  final String imagePath;
  final double rating;
  final double ?width;

  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.onTap,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = SizeUtils.getWidth(context: context);
    final screenHeight = SizeUtils.getHeight(context: context);

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width:width ??screenWidth * 0.49,
        height: screenHeight * 0.34,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(screenWidth * 0.04),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.error, color: Colors.white),
              ),
            ),

            Positioned(
              top: screenHeight * 0.016,
              right: screenWidth * 0.035,
              child: Container(
                height: screenHeight * 0.037,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.013),
                decoration: BoxDecoration(
                  color: AppColors.liteGrey,
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.starIcon,
                      width: screenWidth * 0.037,
                      height: screenHeight * 0.018,
                    ),
                    SizedBox(width: screenWidth * 0.01),
                    Text('$rating', style: AppStyles.regular16White),
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
