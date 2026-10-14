import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';

class MovieCard extends StatelessWidget {
  final String imagePath;
  final double rating;
  final VoidCallback onTap;

  const MovieCard({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 184.w,
        height: 277.h,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child:
              CachedNetworkImage(
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

              // Image.asset(
              //   imagePath,
              //   width: double.infinity,
              //   height: double.infinity,
              //   fit: BoxFit.cover,
              // ),
            ),

            Positioned(
              top: 13.h,
              right: 14.w,
              child: Container(
                height: 30.h,
                padding: EdgeInsets.symmetric(horizontal: 5.w),

                decoration: BoxDecoration(
                  color: AppColors.liteGrey,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.starIcon,
                      width: 14.w,
                      height: 14.h,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                     " $rating",
                      style: AppStyles.regular16White,
                    ),
                  ],
                ),
              ),
            )          ],
        ),
      ),
    );
  }
}
