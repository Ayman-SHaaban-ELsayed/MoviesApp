import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class GenresSection extends StatelessWidget {
  final List<String> genres;

  const GenresSection({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) return const SizedBox.shrink();

    final height = context.height;
    final width = context.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              AppLocalizations.of(context)!.genres,
              style: AppStyles.bold24White,
            ),
          ),
          SizedBox(height: height * 0.02),
          Wrap(
            spacing: width * 0.03,
            runSpacing: height * 0.015,
            children: genres.map((genre) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff282A28),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                child: Text(
                  genre,
                  style: AppStyles.regular16White,
                ),
              );
            }).toList(),
          ),
          SizedBox(height: height * 0.015),
        ],
      ),
    );
  }
}