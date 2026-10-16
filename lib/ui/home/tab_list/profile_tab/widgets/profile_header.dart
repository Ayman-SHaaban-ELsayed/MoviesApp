import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../l10n/app_localizations.dart';
import '../../../../../../model/my_user.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_styles.dart';
import '../profile_cubit.dart';
import '../update_profile_screen.dart';
import 'avatar_picker_bottom_sheet.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                      width: 100,
                      height: 100,
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
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        user.name,
                        style: AppStyles.bold20White.copyWith(fontSize: 14),
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
                  count: '${cubit.watchListCount}',
                  label: locale.watchList,
                ),
              ),

              Expanded(
                flex: 4,
                child: _buildStatItem(
                  count: '${cubit.historyCount}',
                  label: locale.history,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // أزرار التحكم (Edit Profile & Exit)
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
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
                    style: AppStyles.regular20Black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: onExitPressed,
                  label: Text(
                    locale.exit,
                    style: AppStyles.bold20White.copyWith(fontSize: 16),
                  ),
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.white,
                    size: 20,
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

  Widget _buildStatItem({required String count, required String label}) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            count,
            style: AppStyles.bold36White,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppStyles.bold24White,
          ),
        ],
      ),
    );
  }
}