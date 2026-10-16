class OnboardingModel {
  final String imagePath;
  final String title;
  final String description;
  final bool isFirst;

  OnboardingModel({
    required this.imagePath,
    required this.title,
    required this.description,
    this.isFirst = false,
  });
}
