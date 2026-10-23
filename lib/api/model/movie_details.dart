class MovieDetails {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final String largeCoverImage;
  final String description;
  final List<String> screenshots;

  MovieDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.largeCoverImage,
    required this.description,
    required this.screenshots,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    List<String> screenshots = [];

    // دالة صغيرة تتأكد إن اللينك موجود ومش فاضي
    void addScreenshot(String? url) {
      if (url != null && url.isNotEmpty) {
        screenshots.add(url);
      }
    }

    // بنحاول نجيب الصور بجميع أحجامها المتاحة
    addScreenshot(json['medium_screenshot_image1']?.toString());
    addScreenshot(json['medium_screenshot_image2']?.toString());
    addScreenshot(json['medium_screenshot_image3']?.toString());

    // لو مفيش ميديم، بنجرب ناخد لارج
    if (screenshots.isEmpty) {
      addScreenshot(json['large_screenshot_image1']?.toString());
      addScreenshot(json['large_screenshot_image2']?.toString());
      addScreenshot(json['large_screenshot_image3']?.toString());
    }

    return MovieDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      largeCoverImage: json['large_cover_image'] ?? '',
      description: json['description_full'] ?? '',
      screenshots: screenshots,
    );
  }
}