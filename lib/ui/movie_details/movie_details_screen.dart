import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/fireStore/firebase_utils.dart';
import 'package:movies_app/model/movie_item_ui_model.dart'; // الكلاس الجديد
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';
import 'package:movies_app/utils/size_utils.dart';
import 'web_view_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetails> _movieDetailsFuture;
  bool _isInWatchlist = false;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = DioManager.getMovieDetails(widget.movieId);
    _checkWatchlistStatus();
  }

  void _checkWatchlistStatus() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? SharedPrefUtils.userId;
    if (userId != null && userId.isNotEmpty && userId != 'preview_user') {
      final inList = await FirebaseUtils.isMovieInWatchlist(
        userId,
        widget.movieId.toString(),
      );
      if (mounted) {
        setState(() {
          _isInWatchlist = inList;
        });
      }
    }
  }

  Future<void> _toggleWatchlist(MovieDetails movie) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? SharedPrefUtils.userId;
    if (userId == null || userId.isEmpty || userId == 'preview_user') {
      Fluttertoast.showToast(msg: "Please login first");
      return;
    }

    final movieItem = MovieItemUiModel(
      id: movie.id.toString(),
      title: movie.title,
      rating: movie.rating.toString(),
      imagePath: movie.largeCoverImage,
      year: movie.year.toString(),
    );

    try {
      if (_isInWatchlist) {
        await FirebaseUtils.removeFromWatchlist(userId, movie.id.toString());
        if (mounted) {
          setState(() => _isInWatchlist = false);
          Fluttertoast.showToast(msg: "Removed from Watch List");
        }
      } else {
        await FirebaseUtils.addToWatchlist(userId, movieItem);
        if (mounted) {
          setState(() => _isInWatchlist = true);
          Fluttertoast.showToast(msg: "Added to Watch List");
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  Future<void> _addToHistory(MovieDetails movie) async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? SharedPrefUtils.userId;
    if (userId == null || userId.isEmpty || userId == 'preview_user') {
      return;
    }

    final movieItem = MovieItemUiModel(
      id: movie.id.toString(),
      title: movie.title,
      rating: movie.rating.toString(),
      imagePath: movie.largeCoverImage,
      year: movie.year.toString(),
    );

    try {
      await FirebaseUtils.addToHistory(userId, movieItem);
      // Fluttertoast.showToast(msg: "Added to History"); // ممكن تشيلها عشان متزعجش اليوزر
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: FutureBuilder<MovieDetails>(
        future: _movieDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.yellow),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error loading movie', style: AppStyles.regular16White),
            );
          }

          final movie = snapshot.data!;

          return Stack(
            children: [
              // 1. صورة الخلفية
              Positioned.fill(
                child: Image.network(
                  movie.largeCoverImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.darkGrey,
                  ),
                ),
              ),

              // 2. التدرج اللوني
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.1),
                        AppColors.primary.withValues(alpha: 0.8),
                        AppColors.primary,
                        AppColors.primary,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // 3. المحتوى
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // الشريط العلوي
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            IconButton(
                              icon: Image.asset(
                                AppAssets.favouriteIcon,
                                color: _isInWatchlist ? AppColors.yellow : AppColors.white, // بيتلون أصفر
                                width: 24,
                              ),
                              onPressed: () => _toggleWatchlist(movie), // بينفذ الحفظ
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.15),

                      // زر التشغيل (بيسجل في الـ History)
                      GestureDetector(
                        onTap: () => _addToHistory(movie),
                        child: Image.asset(
                          AppAssets.playMovie,
                          width: 90,
                          height: 90,
                        ),
                      ),

                      SizedBox(height: height * 0.04),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          children: [
                            // اسم الفيلم
                            Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: AppStyles.bold24White,
                            ),
                            SizedBox(height: height * 0.01),

                            // السنة
                            Text(
                              '${movie.year}',
                              style: AppStyles.regular16White.copyWith(
                                color: AppColors.lightGrey,
                              ),
                            ),
                            SizedBox(height: height * 0.03),

                            // زر Watch (بيسجل في الـ History ويفتح الـ WebView)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffE82626),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: height * 0.015),
                                ),
                                onPressed: () {
                                  _addToHistory(movie); // تسجيل في التاريخ
                                  if (movie.url.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewScreen(
                                          url: movie.url,
                                          title: movie.title,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  'Watch',
                                  style: AppStyles.bold20White,
                                ),
                              ),
                            ),

                            SizedBox(height: height * 0.03),

                            // شريط الإحصائيات
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatChip(
                                    iconPath: AppAssets.likeIcon,
                                    text: '${movie.likeCount}',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildStatChip(
                                    iconPath: AppAssets.durationIcon,
                                    text: '${movie.runtime}',
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _buildStatChip(
                                    iconPath: AppAssets.starIcon,
                                    text: '${movie.rating}',
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: height * 0.04),

                            // قسم السكرين شوت (عمودي وبعرض الشاشة)
                            if (movie.screenshots.isNotEmpty) ...[
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: Text(
                                  'Screenshots',
                                  style: AppStyles.bold20White,
                                ),
                              ),
                              SizedBox(height: height * 0.015),

                              ...movie.screenshots.map((url) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      url,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          height: 150,
                                          color: AppColors.darkGrey,
                                          child: const Icon(
                                            Icons.broken_image,
                                            color: AppColors.white,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                            SizedBox(height: height * 0.05),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatChip({required String iconPath, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            iconPath,
            color: AppColors.yellow,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppStyles.regular16White,
          ),
        ],
      ),
    );
  }
}