import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class ScreenshotsSection extends StatelessWidget {
  final List<String> screenshots;

  const ScreenshotsSection({super.key, required this.screenshots});

  @override
  Widget build(BuildContext context) {
    if (screenshots.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            AppLocalizations.of(context)!.screenShots,
            style: AppStyles.bold20White,
          ),
        ),
        SizedBox(height: context.height * 0.015),
        ...screenshots.map(
          (url) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                url,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: AppColors.darkGrey,
                  child: const Icon(Icons.broken_image, color: AppColors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
