import 'package:flutter/material.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/utils/app_assets.dart';

import 'stat_chip.dart';

class MovieStatsRow extends StatelessWidget {
  final MovieDetails movie;

  const MovieStatsRow({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatChip(
            iconPath: AppAssets.likeIcon,
            text: '${movie.likeCount}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatChip(
            iconPath: AppAssets.durationIcon,
            text: '${movie.runtime}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: StatChip(
            iconPath: AppAssets.starIcon,
            text: '${movie.rating}',
          ),
        ),
      ],
    );
  }
}
