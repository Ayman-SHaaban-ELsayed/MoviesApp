import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/locale_cubit.dart';

class LanguageSwitchWidget extends StatelessWidget {
  const LanguageSwitchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, Locale?>(
      builder: (context, locale) {
        final currentCode =
            locale?.languageCode ??
            Localizations.localeOf(context).languageCode;

        final isArabic = currentCode == 'ar';

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.darkGrey,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: AppColors.yellow, width: 1.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    if (isArabic) {
                      context.read<LocaleCubit>().changeLanguage('en');
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: !isArabic ? AppColors.yellow : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(AppAssets.enLang, width: 24, height: 24),
                  ),
                ),

                const SizedBox(width: 6),

                GestureDetector(
                  onTap: () {
                    if (!isArabic) {
                      context.read<LocaleCubit>().changeLanguage('ar');
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isArabic ? AppColors.yellow : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(AppAssets.arLang, width: 24, height: 24),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
