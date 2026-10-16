import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';

import '../../../../utils/app_colors.dart';

class BrowseTab extends StatelessWidget {
  const BrowseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.browse,
        style: const TextStyle(color: AppColors.white),
      ),
    );
  }
}
