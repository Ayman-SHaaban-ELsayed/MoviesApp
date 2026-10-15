import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../l10n/app_localizations.dart';
import '../../../model/my_user.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_styles.dart';
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              // User Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.yellow, width: 2.5),
                ),
                child: ClipOval(
                  child: Image.asset(
                    AvatarPickerBottomSheet.getAvatarPath(user.avatarId),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Name & Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppStyles.bold20White,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Stats: Wish List & History
                    Row(
                      children: [
                        _buildStatItem(
                          count: '${cubit.watchListCount}',
                          label: locale.watchList,
                        ),
                        const SizedBox(width: 28),
                        _buildStatItem(
                          count: '${cubit.historyCount}',
                          label: locale.history,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Action Buttons: Edit Profile & Exit
          Row(
            children: [
              // Edit Profile Button (Yellow)
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.yellow,
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
                    style: AppStyles.bold20Black.copyWith(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Exit Button (Red)
              Expanded(
                flex: 1,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: onExitPressed,
                  icon: const Icon(
                    Icons.exit_to_app_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                  label: Text(
                    locale.exit,
                    style: AppStyles.bold20White.copyWith(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({required String count, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          count,
          style: AppStyles.bold24White.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.regular14White.copyWith(
            color: AppColors.lightGrey,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
