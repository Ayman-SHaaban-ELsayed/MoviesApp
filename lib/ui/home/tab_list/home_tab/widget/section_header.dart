import 'package:flutter/material.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';
import '../../../../../utils/size_utils.dart';

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
    final height = context.height;
    final width = context.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.025),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppStyles.regular20White),
          GestureDetector(
            onTap: onSeeMoreTap,
            child: Row(
              children: [
                Text(seeMoreText, style: AppStyles.regular16Yellow),
                SizedBox(width: width * 0.01),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.yellow,
                  size: height * 0.018,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
