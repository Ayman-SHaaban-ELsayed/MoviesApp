import 'package:flutter/material.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/home/tab_list/browse_tab/browse_tab.dart';
import 'package:movies_app/ui/home/tab_list/home_tab/home_tab.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/profile_tab.dart';
import 'package:movies_app/ui/home/tab_list/search_tab/search_tab.dart';

import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/size_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
     final width = context.width;
    final List<Widget> tabs = [
      const HomeTab(),
      SearchTab(),
      BrowseTab(),
      ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: tabs[_currentIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(width * 0.023),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.yellow,
          unselectedItemColor: AppColors.white,
          items: [
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage(AppAssets.homeIcon)),
              label: AppLocalizations.of(context)!.home,
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage(AppAssets.searchIcon)),
              label: AppLocalizations.of(context)!.search,
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage(AppAssets.browseIcon)),
              label: AppLocalizations.of(context)!.browse,
            ),
            BottomNavigationBarItem(
              icon: const ImageIcon(AssetImage(AppAssets.profileIcon)),
              label: AppLocalizations.of(context)!.profile,
            ),
          ],
        ),
      ),
    );
  }
}
