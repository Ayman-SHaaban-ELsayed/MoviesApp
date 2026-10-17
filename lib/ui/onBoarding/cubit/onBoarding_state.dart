abstract class OnboardState {}

class OnboardInitial extends OnboardState {
  final int currentIndex;

  OnboardInitial({required this.currentIndex});
}