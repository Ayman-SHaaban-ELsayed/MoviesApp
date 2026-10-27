import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/cubit/search_cubit.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/cubit/search_states.dart';
import 'package:movies_app/ui/movie_details/movie_details_screen.dart';
import 'package:movies_app/ui/widgets/custom_text_form_field.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';
import 'widgets/movie_card.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const _SearchTabContent(),
    );
  }
}

class _SearchTabContent extends StatefulWidget {
  const _SearchTabContent();

  @override
  State<_SearchTabContent> createState() => _SearchTabContentState();
}

class _SearchTabContentState extends State<_SearchTabContent> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<SearchCubit>().loadMoreMovies();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
            child: CustomTextFormField(
              controller: _searchController,
              style: AppStyles.regular16White,
              curserColor: AppColors.white,
              hintText: 'Search...',
              hintStyle: AppStyles.regular16grey,
              onChanged: (query) {
                context.read<SearchCubit>().searchMovies(query);
              },
              prefixIcon: const ImageIcon(
                AssetImage(AppAssets.searchIcon),
                color: AppColors.white,
                size: 28,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _searchController,
                builder: (context, value, _) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.grey,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      context.read<SearchCubit>().clearSearch();
                    },
                  );
                },
              ),
              fill: true,
              filledColor: AppColors.darkGrey,
              borderColor: Colors.transparent,
            ),
          ),

          Expanded(
            child: BlocBuilder<SearchCubit, SearchStates>(
              builder: (context, state) {
                if (state is SearchLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.yellow,
                    ),
                  );
                }

                if (state is SearchErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        state.errorMessage,
                        style: AppStyles.regular16White,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (state is SearchEmptyState) {
                  return _buildEmptyState(context);
                }

                if (state is SearchSuccessState ||
                    state is SearchLoadingMoreState) {
                  final movies = (state is SearchSuccessState)
                      ? state.movies
                      : (state as SearchLoadingMoreState).currentMovies;
                  final isLoadingMore = state is SearchLoadingMoreState;

                  if (movies.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: movies.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == movies.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                              color: AppColors.yellow,
                            ),
                          ),
                        );
                      }

                      final movie = movies[index];
                      return MovieCard(
                        movie: movie,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetailsScreen(
                                movieId: movie.id,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }

                return _buildEmptyState(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.emptyLogo,
        width: context.width * 0.42,
        fit: BoxFit.contain,
      ),
    );
  }
}