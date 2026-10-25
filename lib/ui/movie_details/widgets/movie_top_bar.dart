import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/size_utils.dart';

class MovieTopBar extends StatelessWidget {
  final bool isInWatchlist;
  final VoidCallback onWatchlistTap;

  const MovieTopBar({
    super.key,
    required this.isInWatchlist,
    required this.onWatchlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: Image.asset(
              AppAssets.favouriteIcon,
              color: isInWatchlist ? AppColors.yellow : AppColors.white,
              width: 24,
            ),
            onPressed: onWatchlistTap,
          ),
        ],
      ),
    );
  }
}
