import 'package:flutter/material.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class CastSection extends StatelessWidget {
  final List<Cast> cast;

  const CastSection({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

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
              AppLocalizations.of(context)!.cast,
              style: AppStyles.bold24White,
            ),
          ),
          SizedBox(height: height * 0.02),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final actor = cast[index];
              return Container(
                margin: EdgeInsets.only(bottom: height * 0.015),
                padding: EdgeInsets.all(width * 0.02),
                decoration: BoxDecoration(
                  color: const Color(0xff282A28),
                  borderRadius: BorderRadius.circular(width * 0.035),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      child: Image.network(
                        actor.urlSmallImage,
                        width: width * 0.14,
                        height: width * 0.14,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: width * 0.14,
                            height: width * 0.14,
                            color: AppColors.grey,
                            child: Icon(
                              Icons.broken_image,
                              color: AppColors.white,
                              size: width * 0.06,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name : ${actor.name}',
                            style: AppStyles.regular16White,
                          ),
                          SizedBox(height: height * 0.005),
                          Text(
                            'Character : ${actor.characterName}',
                            style: AppStyles.regular16White,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: height * 0.015),
        ],
      ),
    );
  }
}