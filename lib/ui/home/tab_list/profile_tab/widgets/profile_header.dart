import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/model/my_user.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_cubit.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/update_profile_screen.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/avatar_picker_bottom_sheet.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/size_utils.dart';

class ProfileHeader extends StatelessWidget {
  final MyUser user;
  final ProfileCubit cubit;
  final VoidCallback onExitPressed;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.cubit,
    required this.onExitPressed,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.width * 0.03,
        vertical: context.height * 0.015,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: context.width * 0.25,
                      height: context.width * 0.25,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AvatarPickerBottomSheet.getAvatarPath(user.avatarId),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: context.height * 0.015),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        user.name,
                        style: AppStyles.bold20White,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 4,
                child: _buildStatItem(
                  context: context,
                  count: '${cubit.watchListCount}',
                  label: locale.watchList,
                ),
              ),

              Expanded(
                flex: 4,
                child: _buildStatItem(
                  context: context,
                  count: '${cubit.historyCount}',
                  label: locale.history,
                ),
              ),
            ],
          ),
          SizedBox(height: context.height * 0.025),

          Row(
            children: [
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.015,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: UpdateProfileScreen(user: user),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    locale.editProfile,
                    style: AppStyles.regular16Black,
                  ),
                ),
              ),
              SizedBox(width: context.width * 0.025),
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: context.height * 0.015,
                    ),
                  ),
                  onPressed: onExitPressed,
                  label: Text(
                    locale.exit,
                    style: AppStyles.regular16White,
                  ),
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.white,
                    size: context.width * 0.05,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String count,
    required String label,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.height * 0.05,
        left: context.width * 0.04,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count,
              style: AppStyles.bold24White,
            ),
            SizedBox(height: context.height * 0.012),
            Text(
              label,
              style: AppStyles.bold24White,
            ),
          ],
        ),
      ),
    );
  }
}