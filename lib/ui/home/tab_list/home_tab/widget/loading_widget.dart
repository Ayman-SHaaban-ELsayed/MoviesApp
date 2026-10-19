import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  final Color indicatorColor;
  final Color textColor;
  final double spacing;
  final String? message;

  const LoadingWidget({
    super.key,
    this.indicatorColor = AppColors.yellow,
    this.textColor = AppColors.white,
    this.spacing = 16,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: indicatorColor),
          SizedBox(height: spacing),
          Text(
            message ?? AppLocalizations.of(context)!.loading,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
