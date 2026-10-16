import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/ui/widgets/custom_dialog.dart';
import 'package:movies_app/ui/widgets/custom_text_form_field.dart';
import 'package:movies_app/ui/widgets/elevated_button_reuse.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../../../model/my_user.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_styles.dart';
import 'profile_cubit.dart';
import 'profile_states.dart';
import 'widgets/avatar_picker_bottom_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
  final MyUser? user;

  const UpdateProfileScreen({super.key, this.user});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late int _selectedAvatarId;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _selectedAvatarId = (user?.avatarId ?? 1).clamp(1, 9);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdatedSuccessState) {
          bool navigated = false;
          void navigateBack() {
            if (!navigated && context.mounted) {
              navigated = true;
              CustomDialog.hide(context);
              Navigator.pop(context);
            }
          }

          CustomDialog.showSuccess(
            context: context,
            message: local.profileUpdatedSuccess,
            buttonText: local.close,
          ).then((_) => navigateBack());

          Future.delayed(const Duration(milliseconds: 900), navigateBack);
        } else if (state is ProfileDeleteSuccessState) {
          Navigator.pop(context);
        } else if (state is ProfileErrorState) {
          CustomDialog.showError(
            context: context,
            message: state.errorMessage,
            buttonText: local.close,
          );
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final isUpdating = state is ProfileUpdatingState;

        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.yellow),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              local.pickAvatar,
              style: AppStyles.regular16Yellow.copyWith(fontSize: 18),
            ),
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),

                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    AvatarPickerBottomSheet.show(
                                      context: context,
                                      selectedAvatarId: _selectedAvatarId,
                                      onAvatarSelected: (id) {
                                        setState(() {
                                          _selectedAvatarId = id;
                                        });
                                        cubit.selectAvatar(id);
                                      },
                                    );
                                  },
                                  child: Container(
                                    width: 140,
                                    height: 140,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        AvatarPickerBottomSheet.getAvatarPath(
                                          _selectedAvatarId,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),

                              CustomTextFormField(
                                controller: _nameController,
                                fill: true,
                                filledColor: AppColors.darkGrey,
                                hinttext: local.name,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                ),
                                style: AppStyles.bold20White,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return local.nameRequired;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              CustomTextFormField(
                                controller: _phoneController,
                                fill: true,
                                filledColor: AppColors.darkGrey,
                                hinttext: local.phoneNumber,
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: AppColors.white,
                                ),
                                keyboradtype: TextInputType.phone,
                                style: AppStyles.bold20White,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return local.phoneRequired;
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    cubit.resetPassword();
                                    CustomDialog.showSuccess(
                                      context: context,
                                      message: local.passwordResetEmailSent,
                                      buttonText: local.close,
                                    );
                                  },
                                  child: Text(
                                    local.resetPassword,
                                    style: AppStyles.regular16White,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              ElevatedButtonReuse(
                                background: AppColors.red,
                                onpressed: () => _confirmDeleteAccount(
                                  context,
                                  local,
                                  cubit,
                                ),
                                ChildType: Text(
                                  local.deleteAccount,
                                  style: AppStyles.bold20White,
                                ),
                              ),
                              const SizedBox(height: 14),

                              ElevatedButtonReuse(
                                background: AppColors.yellow,
                                onpressed: isUpdating
                                    ? () {}
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          cubit.updateProfile(
                                            name: _nameController.text.trim(),
                                            phone: _phoneController.text.trim(),
                                            avatarId: _selectedAvatarId,
                                          );
                                        }
                                      },
                                ChildType: isUpdating
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Text(
                                        local.updateData,
                                        style: AppStyles.bold20Black,
                                      ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _confirmDeleteAccount(
    BuildContext context,
    AppLocalizations local,
    ProfileCubit cubit,
  ) {
    CustomDialog.showTwoButtons(
      context: context,
      title: local.deleteAccount,
      titleColor: AppColors.red,
      body: local.deleteAccountConfirmation,
      confirmText: local.delete,
      confirmColor: AppColors.red,
      cancelText: local.cancel,
      cancelTextColor: AppColors.yellow,
      onConfirm: () => cubit.deleteAccount(),
    );
  }
}
