import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_assets.dart';

class MoviePlayButton extends StatelessWidget {
  final VoidCallback onTap;

  const MoviePlayButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(AppAssets.playMovie, width: 90, height: 90),
    );
  }
}
