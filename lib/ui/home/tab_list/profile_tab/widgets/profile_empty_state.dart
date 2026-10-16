import 'package:flutter/material.dart';

import '../../../../../../utils/app_assets.dart';
import '../../../../../../utils/size_utils.dart';

class ProfileEmptyState extends StatelessWidget {

  const ProfileEmptyState({super.key,});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              AppAssets.emptyLogo,
              width: context.width * 0.42,
              fit: BoxFit.contain,
            ),

          ],
        ),
      ),
    );
  }
}
