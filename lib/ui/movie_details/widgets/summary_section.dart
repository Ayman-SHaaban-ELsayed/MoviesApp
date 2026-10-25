import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class SummarySection extends StatelessWidget {
  final String summary;

  const SummarySection({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.width * 0.05),
      child: Column(
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(l10n.summary, style: AppStyles.bold24White),
          ),
          SizedBox(height: context.height * 0.015),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              summary
                  .trim()
                  .isEmpty ? l10n.noSummaryAvailable : summary,
              style: AppStyles.regular16White,
            ),
          ),
        ],
      ),
    );
  }
}