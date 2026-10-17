import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_states.dart';
import 'package:movies_app/ui/widgets/custom_dialog.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../model/my_user.dart';
import '../../../../../utils/app_assets.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_routes.dart';
import '../../../../../utils/app_styles.dart';
import 'cubit/profile_cubit.dart';
 import 'widgets/history_tab_view.dart';
import 'widgets/profile_header.dart';
import 'widgets/watch_list_tab_view.dart';

class ProfileTab extends StatelessWidget {
  final MyUser? user;

  const ProfileTab({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit()..loadUser(user),
      child: const _ProfileTabView(),
    );
  }
}

class _ProfileTabView extends StatelessWidget {
  const _ProfileTabView();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final cubit = context.read<ProfileCubit>();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLogoutSuccessState ||
            state is ProfileDeleteSuccessState) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.loginRouteName,
            (route) => false,
          );
        } else if (state is ProfileErrorState) {
          CustomDialog.showError(
            context: context,
            message: state.errorMessage,
            buttonText: locale.close,
          );
        }
      },
      builder: (context, state) {
        final user =
            cubit.currentUser ??
            MyUser(
              id: 'preview_user',
              name: 'John Doe',
              email: 'johndoe@example.com',
              phone: '+20 123 456 7890',
              avatarId: 1,
            );

        return Scaffold(
          backgroundColor: AppColors.primary,
          body: SafeArea(
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  ProfileHeader(
                    user: user,
                    cubit: cubit,
                    onExitPressed: () =>
                        _showLogoutDialog(context, locale, cubit),
                  ),

                  const SizedBox(height: 16),

                  _buildTabBar(locale),

                  Expanded(
                    child: TabBarView(
                      children: [
                        WatchListTabView(cubit: cubit),
                        HistoryTabView(cubit: cubit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar(AppLocalizations locale) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.darkGrey, width: 1.5),
        ),
      ),
      child: TabBar(
        indicatorColor: AppColors.yellow,
        indicatorWeight: 3.5,
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.yellow,
        unselectedLabelColor: AppColors.white,
        labelStyle: AppStyles.bold14Yellow,
        unselectedLabelStyle: AppStyles.regular16White,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.watchListIcon,
                  width: 22,
                  height: 22,
                  color: AppColors.yellow,
                ),
                const SizedBox(width: 8),
                Text(locale.watchList),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppAssets.historyIcon,
                  width: 22,
                  height: 22,
                  color: AppColors.yellow,
                ),
                const SizedBox(width: 8),
                Text(locale.history),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(
    BuildContext context,
    AppLocalizations locale,
    ProfileCubit cubit,
  ) {
    CustomDialog.showTwoButtons(
      context: context,
      title: locale.exit,
      body: locale.logoutConfirmation,
      confirmText: locale.exit,
      confirmColor: AppColors.red,
      cancelText: locale.cancel,
      cancelTextColor: AppColors.yellow,
      onConfirm: () => cubit.logout(),
    );
  }
}
