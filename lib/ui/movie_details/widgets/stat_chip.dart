import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class StatChip extends StatelessWidget {
  final String iconPath;
  final String text;

  const StatChip({super.key, required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(iconPath, color: AppColors.yellow, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(text, style: AppStyles.regular16White),
        ],
      ),
    );
  }
}