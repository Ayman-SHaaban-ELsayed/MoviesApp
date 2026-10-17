import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/data/models/onBoarding_model.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/onBoarding/cubit/onBoarding_cubit.dart';
import 'package:movies_app/ui/onBoarding/cubit/onBoarding_state.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final List<OnboardingModel> onboardingItems = [
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg1,
        title: AppLocalizations.of(context)!.onboardingTitle1,
        description: AppLocalizations.of(context)!.onboardingDesc1,
        isFirst: true,
      ),
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg2,
        title: AppLocalizations.of(context)!.onboardingTitle2,
        description: AppLocalizations.of(context)!.onboardingDesc2,
      ),
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg3,
        title: AppLocalizations.of(context)!.onboardingTitle3,
        description: AppLocalizations.of(context)!.onboardingDesc3,
      ),
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg4,
        title: AppLocalizations.of(context)!.onboardingTitle4,
        description: AppLocalizations.of(context)!.onboardingDesc4,
      ),
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg5,
        title: AppLocalizations.of(context)!.onboardingTitle5,
        description: AppLocalizations.of(context)!.onboardingDesc5,
      ),
      OnboardingModel(
        imagePath: AppAssets.onBoardingPg6,
        title: AppLocalizations.of(context)!.onboardingTitle6,
        description: '',
      ),
    ];

    return BlocProvider(
      create: (context) => OnboardCubit(),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: BlocBuilder<OnboardCubit, OnboardState>(
          builder: (context, state) {
            final cubit = context.read<OnboardCubit>();
            final currentItem = onboardingItems[cubit.currentIndex];
            final bool isLastPage =
                cubit.currentIndex == onboardingItems.length - 1;

            return Stack(
              children: [
                PageView.builder(
                  controller: cubit.pageController,
                  itemCount: onboardingItems.length,
                  onPageChanged: cubit.onPageChanged,
                  itemBuilder: (context, index) {
                    final item = onboardingItems[index];
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            item.imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.transparent,
                                  AppColors.primary,
                                  AppColors.darkGrey,
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.3, 0.8, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: currentItem.isFirst ? double.infinity : null,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: width * 0.05,
                      vertical: height * 0.03,
                    ),
                    decoration: BoxDecoration(
                      color: currentItem.isFirst
                          ? AppColors.transparent
                          : AppColors.primary,
                      borderRadius: currentItem.isFirst
                          ? null
                          : BorderRadius.only(
                        topLeft: Radius.circular(width * 0.05),
                        topRight: Radius.circular(width * 0.05),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: currentItem.isFirst
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentItem.title,
                          textAlign: TextAlign.center,
                          style: AppStyles.bold20White,
                        ),
                        SizedBox(height: height * 0.015),
                        if (currentItem.description.isNotEmpty) ...[
                          Text(
                            currentItem.description,
                            textAlign: TextAlign.center,
                            style: currentItem.isFirst
                                ? AppStyles.regular16grey
                                : AppStyles.regular16White,
                          ),
                          SizedBox(height: height * 0.025),
                        ],
                        SizedBox(
                          width: double.infinity,
                          height: height * 0.06,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.yellow,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    width * 0.03),
                              ),
                            ),
                            onPressed: () =>
                                cubit.nextButtonTapped(onboardingItems.length),
                            child: Text(
                              currentItem.isFirst
                                  ? AppLocalizations.of(context)!.exploreNow
                                  : isLastPage
                                  ? AppLocalizations.of(context)!.finish
                                  : AppLocalizations.of(context)!.next,
                              style: AppStyles.semibold20Black,
                            ),
                          ),
                        ),
                        if (cubit.currentIndex > 1) ...[
                          SizedBox(height: height * 0.015),
                          SizedBox(
                            width: double.infinity,
                            height: height * 0.06,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: AppColors.yellow),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      width * 0.03),
                                ),
                              ),
                              onPressed: cubit.previousButtonTapped,
                              child: Text(
                                AppLocalizations.of(context)!.back,
                                style: AppStyles.semibold20Yellow,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}