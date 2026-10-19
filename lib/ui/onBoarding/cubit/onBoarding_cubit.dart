import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/onBoarding/cubit/onBoarding_state.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(OnboardInitial(currentIndex: 0));

  final PageController pageController = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    emit(OnboardInitial(currentIndex: currentIndex));
  }

  Future<void> nextButtonTapped(int totalItems) async {
    if (currentIndex < totalItems - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      await SharedPrefUtils.saveOnboardingSeen(true);
      emit(OnboardNavigateToLoginState());
    }
  }

  void previousButtonTapped() {
    if (currentIndex > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}
