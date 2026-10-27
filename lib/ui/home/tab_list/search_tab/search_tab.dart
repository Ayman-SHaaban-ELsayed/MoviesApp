import 'package:flutter/material.dart';
import 'package:movies_app/model/movie_item_ui_model.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';
import 'widgets/movie_card.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();

  // البيانات التجريبية
  final List<MovieItemUiModel> _allMovies = [
    MovieItemUiModel(id: '1', title: 'Black Widow', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/qAZ0pzat24kLdO3o0ejrPAeH2kE.jpg', year: '2021'),
    MovieItemUiModel(id: '2', title: 'Captain America', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/vSNxAJTlD0r02V9sPYpOjqDZXUK.jpg', year: '2011'),
    MovieItemUiModel(id: '3', title: 'Iron Man 3', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/1Ilv6ryHUv6rt9zIsbSEJUmmbEi.jpg', year: '2013'),
    MovieItemUiModel(id: '4', title: 'Civil War', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/rAGiXaUfPzY7CDEyNKUofk3Kw2e.jpg', year: '2016'),
    MovieItemUiModel(id: '5', title: 'Avengers', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/RYMX2wcKCBAr24UyPD7xwmja4Q.jpg', year: '2012'),
    MovieItemUiModel(id: '6', title: 'Doctor Strange', rating: '7.7', imagePath: 'https://image.tmdb.org/t/p/w500/uGBVj3bEbCoZbDjjl9wTxcygko1.jpg', year: '2016'),
  ];

  List<MovieItemUiModel> _filteredMovies = [];

  @override
  void initState() {
    super.initState();
    _filteredMovies = _allMovies;
    _searchController.addListener(_filterMovies);
  }

  void _filterMovies() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredMovies = _allMovies;
      } else {
        _filteredMovies = _allMovies
            .where((movie) => movie.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.darkGrey, // تأكد إن اللون ده موجود عندك
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                style: AppStyles.regular16White,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: AppStyles.regular16grey,
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.white,
                    size: 28,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: context.height * 0.018, // تعديل بسيط للارتفاع
                  ),
                ),
              ),
            ),
          ),

          // شبكة الأفلام
          Expanded(
            child: _filteredMovies.isEmpty
                ? Center(
              child: Text(
                'No movies found',
                style: AppStyles.regular16White,
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65, // ده المقاس المناسب للبوسترات
              ),
              itemCount: _filteredMovies.length,
              itemBuilder: (context, index) {
                return MovieCard(
                  movie: _filteredMovies[index],
                  onTap: () {
                    // كود الانتقال لصفحة التفاصيل
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}