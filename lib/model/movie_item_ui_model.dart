class MovieItemUiModel {
  final String id;
  final String title;
  final String rating;
  final String imagePath;
  final String year;

  MovieItemUiModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.imagePath,
    required this.year,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "rating": rating,
      "imagePath": imagePath,
      "year": year,
    };
  }

  factory MovieItemUiModel.fromJson(Map<String, dynamic> json) {
    return MovieItemUiModel(
      id: json["id"] ?? "",
      title: json["title"] ?? "",
      rating: json["rating"] ?? "",
      imagePath: json["imagePath"] ?? "",
      year: json["year"] ?? "",
    );
  }
}