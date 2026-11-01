import 'package:flutter/material.dart';
import 'package:movies_app/ui/movie_details/web_view_screen.dart';
import 'package:movies_app/utils/app_assets.dart';

class MoviePlayButton extends StatelessWidget {
  final String videoId;
  final String movieTitle;
  final VoidCallback? onTap;

  const MoviePlayButton({
    super.key,
    required this.videoId,
    required this.movieTitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
        final String url = videoId.isNotEmpty
            ? 'https://www.youtube.com/embed/$videoId?autoplay=1'
            : 'https://www.youtube.com/results?search_query=${Uri.encodeComponent('$movieTitle trailer')}';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewScreen(
              url: url,
              title: videoId.isNotEmpty ? 'Trailer' : 'Search YouTube',
            ),
          ),
        );
      },
      child: Image.asset(AppAssets.playMovie, width: 90, height: 90),
    );
  }
}