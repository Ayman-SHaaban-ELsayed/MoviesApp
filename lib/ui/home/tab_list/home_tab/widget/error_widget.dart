import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';

class AppErrorWidget extends StatelessWidget {
  final String? message;
  final Color textColor;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    this.message,
    this.textColor = AppColors.white,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message ?? AppLocalizations.of(context)!.failedToLoadMovies,
            style: TextStyle(color: textColor),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry', style: TextStyle(color: Colors.black)),
            ),
          ],
        ],
      ),
    );
  }
}
