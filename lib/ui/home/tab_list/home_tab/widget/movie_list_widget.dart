
import 'package:flutter/material.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/widget/movie_card.dart';

// غيّر مسار الموديل حسب مكانه في مشروعك.
import 'package:movies_app/api/model/movie/movie.dart';

class MovieListWidget extends StatelessWidget {
final List<Movie> movies;
final double height;
final double widthCard;
final double heightCard;
final ValueChanged<Movie>? onMovieTap;

const MovieListWidget({
super.key,
required this.movies,
required this.height,
this.widthCard = 146,
this.heightCard = 220,
this.onMovieTap,
});

@override
Widget build(BuildContext context) {
final screenWidth = MediaQuery.sizeOf(context).width;

return SizedBox(
height: height,
child: ListView.separated(
padding: EdgeInsets.symmetric(
horizontal: screenWidth * 0.04,
),
scrollDirection: Axis.horizontal,
itemCount: movies.length,
separatorBuilder: (context, index) =>
SizedBox(width: screenWidth * 0.03),
itemBuilder: (context, index) {
final movie = movies[index];

return MovieCard(
widthCard: widthCard,
heightCard: heightCard,
imagePath: movie.mediumCoverImage,
rating: movie.rating.toDouble(),
onTap: () {
onMovieTap?.call(movie);
},
);
},
),
);
}
}

