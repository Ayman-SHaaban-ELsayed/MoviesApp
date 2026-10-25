import 'package:flutter/material.dart';
import 'package:movies_app/utils/app_styles.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Browse Tab',
        style: AppStyles.bold24White,
      ),
    );
  }
}