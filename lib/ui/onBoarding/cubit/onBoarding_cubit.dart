import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/onBoarding/cubit/onBoarding_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(OnboardInitial(currentIndex: 0));

  final PageController pageController = PageController();
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    emit(OnboardInitial(currentIndex: currentIndex));
  }

  void nextButtonTapped(int totalItems) {
    if (currentIndex < totalItems - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      //Todo :  Go to home_screen & save the statue in shared pref #walid
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
