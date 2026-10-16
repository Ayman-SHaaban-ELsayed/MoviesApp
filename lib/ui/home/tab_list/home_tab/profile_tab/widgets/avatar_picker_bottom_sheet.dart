import 'package:flutter/material.dart';

import '../../../../../../utils/app_assets.dart';
import '../../../../../../utils/app_colors.dart';

class AvatarPickerBottomSheet extends StatelessWidget {
  static const List<String> avatarAssets = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
  ];

  static String getAvatarPath(int avatarId) {
    final idx = (avatarId - 1).clamp(0, avatarAssets.length - 1);
    return avatarAssets[idx];
  }

  static Future<void> show({
    required BuildContext context,
    required int selectedAvatarId,
    required ValueChanged<int> onAvatarSelected,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => AvatarPickerBottomSheet(
        selectedAvatarId: selectedAvatarId,
        onAvatarSelected: (id) {
          onAvatarSelected(id);
          Navigator.pop(sheetContext);
        },
      ),
    );
  }

  final int selectedAvatarId;
  final ValueChanged<int> onAvatarSelected;

  const AvatarPickerBottomSheet({
    super.key,
    required this.selectedAvatarId,
    required this.onAvatarSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: avatarAssets.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final avatarId = index + 1;
          final isSelected = selectedAvatarId == avatarId;

          return GestureDetector(
            onTap: () => onAvatarSelected(avatarId),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF6B5817)
                    : const Color(0xFF1E1F1E),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.yellow
                      : const Color(0xFFE2B734).withValues(alpha: 0.4),
                  width: isSelected ? 2.5 : 1.2,
                ),
              ),
              child: Image.asset(avatarAssets[index], fit: BoxFit.contain),
            ),
          );
        },
      ),
    );
  }
}
