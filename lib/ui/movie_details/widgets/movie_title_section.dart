import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class MovieTitleSection extends StatelessWidget {
  final String title;
  final int year;

  const MovieTitleSection({super.key, required this.title, required this.year});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, textAlign: TextAlign.center, style: AppStyles.bold24White),
        SizedBox(height: context.height * 0.01),
        Text(
          '$year',
          style: AppStyles.regular16White.copyWith(color: AppColors.lightGrey),
        ),
      ],
    );
  }
}
