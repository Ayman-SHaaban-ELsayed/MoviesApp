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
  final List<Cast> cast;
  final List<String> genres;

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
    required this.cast,
    required this.genres,
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
    List<Cast> castList = [];
    if (json['cast'] != null) {
      json['cast'].forEach((v) {
        castList.add(Cast.fromJson(v));
      });
    }

    List<String> genresList = [];
    if (json['genres'] != null) {
      genresList = List<String>.from(json['genres']);
    }
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
      cast: castList,
      genres: genresList,
    );
  }
}

class Cast {
  final String name;
  final String characterName;
  final String urlSmallImage;

  Cast({
    required this.name,
    required this.characterName,
    required this.urlSmallImage,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'] ?? 'Unknown',
      characterName: json['character_name'] ?? 'Unknown',
      urlSmallImage: json['url_small_image'] ?? '',
    );
  }
}
