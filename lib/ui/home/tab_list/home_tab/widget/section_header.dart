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
    final languageCode = Localizations.localeOf(context).languageCode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.043),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onSeeMoreTap,
            child: Row(
              children: [
                Icon(
                  languageCode == 'ar'
                      ? Icons.arrow_back_rounded
                      : Icons.arrow_forward_rounded,
                  color: AppColors.yellow,
                  size: height * 0.018,
                ),
                SizedBox(width: width * 0.005),
                Text(seeMoreText, style: AppStyles.regular16Yellow),
              ],
            ),
          ),
          Text(title, style: AppStyles.regular20White),
        ],
      ),
    );
  }
}
