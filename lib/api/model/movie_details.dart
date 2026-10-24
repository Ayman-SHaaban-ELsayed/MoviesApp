class MovieDetails {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final String largeCoverImage;
  final String url;
  final List<String> screenshots;
  final String summary;

  MovieDetails({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.largeCoverImage,
    required this.url,
    required this.screenshots,
    required this.summary,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    final List<String> shots = [];

    if (json['medium_screenshot_image1'] != null) {
      shots.add(json['medium_screenshot_image1']);
    }
    if (json['medium_screenshot_image2'] != null) {
      shots.add(json['medium_screenshot_image2']);
    }
    if (json['medium_screenshot_image3'] != null) {
      shots.add(json['medium_screenshot_image3']);
    }

    addShot('medium_screenshot_image1');
    addShot('medium_screenshot_image2');
    addShot('medium_screenshot_image3');

    return MovieDetails(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0).toDouble(),
      runtime: json['runtime'] ?? 0,
      likeCount: json['like_count'] ?? 0,
      largeCoverImage: json['large_cover_image'] ?? '',
      url: json['url'] ?? '',
      screenshots: shots,
      summary: json['description_full']?.toString() ?? '',
    );
  }
}
