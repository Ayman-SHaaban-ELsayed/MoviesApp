import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String seeMoreText;
  final VoidCallback onSeeMoreTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.seeMoreText = 'See More',
    required this.onSeeMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onSeeMoreTap,
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.yellow,
                  size: 15.sp,
                ),
                SizedBox(width: 2.w),
                Text(
                  seeMoreText,
                  style: AppStyles.regular16Yellow,
                ),
              ],
            ),
          ),
          Text(
            title,
            style: AppStyles.regular20White,
          ),
        ],
      ),
    );
  }
}