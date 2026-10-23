import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/api/model/movie_details.dart';
import 'package:movies_app/api/dio_manager.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';
import 'package:movies_app/utils/toast_utils.dart'; // ضيفنا الـ Toast
import 'package:movies_app/ui/widgets/elevated_button_reuse.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetails> _movieDetailsFuture;

  // متغير عشان نحفظ حالة الـ Bookmark
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _movieDetailsFuture = DioManager.getMovieDetails(widget.movieId);
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

          return SingleChildScrollView(
            child: Column(
              children: [
                // --- الجزء العلوي (الصورة والبيانات الأساسية) ---
                Stack(
                  children: [
                    // 1. صورة الخلفية (البوستر)
                    SizedBox(
                      height: height * 0.65,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: movie.largeCoverImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(color: AppColors.yellow),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(Icons.broken_image, color: AppColors.white, size: 50),
                        ),
                      ),
                    ),

                    // 2. التدرج اللوني (Gradient)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.primary.withValues(alpha: 0.2),
                              AppColors.primary.withValues(alpha: 0.6),
                              AppColors.primary,
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                    ),

                    // 3. المحتوى فوق الصورة
                    SafeArea(
                      child: Column(
                        children: [
                          // الشريط العلوي
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.01,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                IconButton(
                                  // 👇 هنا التعديل بتاع الأكشن بتاع الحفظ 👇
                                  icon: Icon(
                                    _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                    color: _isBookmarked ? AppColors.yellow : AppColors.white,
                                    size: 30,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isBookmarked = !_isBookmarked;
                                    });
                                    // رسالة تأكيد
                                    ToastUtils.getFlutterToast(
                                      message: _isBookmarked ? 'Added to Watchlist' : 'Removed from Watchlist',
                                      backGroundColor: AppColors.darkGrey,
                                      textColor: AppColors.white,
                                      fontSize: 14,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: height * 0.15),

                          // زر التشغيل
                          GestureDetector(
                            onTap: () {
                              // تشغيل الفيلم
                            },
                            child: Image.asset(
                              AppAssets.playMovie,
                              width: 90,
                              height: 90,
                            ),
                          ),

                          SizedBox(height: height * 0.15),

                          // اسم الفيلم والسنة
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                            child: Column(
                              children: [
                                Text(
                                  movie.title,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.bold24White,
                                ),
                                SizedBox(height: height * 0.01),
                                Text(
                                  '${movie.year}',
                                  style: AppStyles.regular16White.copyWith(
                                    color: AppColors.lightGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height * 0.02),
                        ],
                      ),
                    ),
                  ],
                ),

                // --- الجزء السفلي (زر Watch والصور) ---
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                  child: Column(
                    children: [
                      // زر Watch
                      ElevatedButtonReuse(
                        background: AppColors.red,
                        onpressed: () {
                          // فتح الفيديو
                        },
                        ChildType: Text(
                          'Watch',
                          style: AppStyles.bold20White,
                        ),
                      ),
                      SizedBox(height: height * 0.02),

                      // شريط الإحصائيات
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatChip(
                            iconPath: AppAssets.likeIcon,
                            text: '${movie.likeCount}',
                          ),
                          _buildStatChip(
                            iconPath: AppAssets.durationIcon,
                            text: '${movie.runtime}',
                          ),
                          _buildStatChip(
                            iconPath: AppAssets.starIcon,
                            text: '${movie.rating}',
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.03),

                      // 👇 عرض صور المشاهد (Screenshots) 👇
                      if (movie.screenshots.isNotEmpty) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            'Screenshots',
                            style: AppStyles.bold20White,
                          ),
                        ),
                        SizedBox(height: height * 0.015),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movie.screenshots.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: movie.screenshots[index],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    height: 180,
                                    color: AppColors.darkGrey,
                                    child: const Center(
                                      child: CircularProgressIndicator(color: AppColors.yellow),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    height: 180,
                                    color: AppColors.darkGrey,
                                    child: const Icon(Icons.broken_image, color: AppColors.white),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ] else ...[
                        // لو مفيش صور مشاهد هتظهر الرسالة دي
                        Text(
                          'No screenshots available for this movie.',
                          style: AppStyles.regular16White.copyWith(color: AppColors.lightGrey),
                        ),
                      ],

                      SizedBox(height: height * 0.04),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatChip({
    required String iconPath,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, color: AppColors.yellow, width: 20, height: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppStyles.bold16Black.copyWith(color: AppColors.white),
          ),
        ],
      ),
    );
  }
}