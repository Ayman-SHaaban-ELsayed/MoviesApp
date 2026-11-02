import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/model/my_user.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_cubit.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/cubit/profile_states.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/widgets/avatar_picker_bottom_sheet.dart';
import 'package:movies_app/ui/widgets/custom_dialog.dart';
import 'package:movies_app/ui/widgets/custom_text_form_field.dart';
import 'package:movies_app/ui/widgets/elevated_button_reuse.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_styles.dart';

class UpdateProfileScreen extends StatefulWidget {
  final MyUser? user;

  const UpdateProfileScreen({
    super.key,
    this.user,
  });

  @override
  State<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  late int _selectedAvatarId;

  bool _isResettingPassword = false;

  @override
  void initState() {
    super.initState();

    final user = widget.user;

    _nameController = TextEditingController(
      text: user?.name ?? '',
    );

    _phoneController = TextEditingController(
      text: user?.phone ?? '',
    );

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
      listener: (context, state) async {
        if (state is ProfileUpdatedSuccessState) {
          await CustomDialog.showSuccess(
            context: context,
            message: local.profileUpdatedSuccess,
            buttonText: local.close,
          );

          if (!context.mounted) return;

          Navigator.pop(context, true);
        } else if (state is ProfileDeleteSuccessState) {
          if (!context.mounted) return;

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
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.yellow,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              local.pickAvatar,
              style: AppStyles.regular16Yellow.copyWith(
                fontSize: 18,
              ),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 24),

                              // Avatar Picker
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    AvatarPickerBottomSheet.show(
                                      context: context,
                                      selectedAvatarId:
                                      _selectedAvatarId,
                                      onAvatarSelected: (id) {
                                        setState(() {
                                          _selectedAvatarId = id;
                                        });

                                        cubit.selectAvatar(id);
                                      },
                                    );
                                  },
                                  child: SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: ClipOval(
                                      child: Image.asset(
                                        AvatarPickerBottomSheet
                                            .getAvatarPath(
                                          _selectedAvatarId,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 36),

                              // Name
                              CustomTextFormField(
                                controller: _nameController,
                                fill: true,
                                filledColor: AppColors.darkGrey,
                                hintText: local.name,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                ),
                                style: AppStyles.bold20White,
                                validator: (value) {
                                  if (value == null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return local.nameRequired;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Phone
                              CustomTextFormField(
                                controller: _phoneController,
                                fill: true,
                                filledColor: AppColors.darkGrey,
                                hintText: local.phoneNumber,
                                prefixIcon: const Icon(
                                  Icons.phone,
                                  color: AppColors.white,
                                ),
                                keyboardType: TextInputType.phone,
                                style: AppStyles.bold20White,
                                validator: (value) {
                                  if (value == null ||
                                      value
                                          .trim()
                                          .isEmpty) {
                                    return local.phoneRequired;
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 16),

                              // Reset Password
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: _isResettingPassword
                                      ? null
                                      : () async {
                                    setState(() {
                                      _isResettingPassword = true;
                                    });

                                    try {
                                      await cubit.resetPassword();

                                      if (!context.mounted) return;

                                      await CustomDialog.showSuccess(
                                        context: context,
                                        message: local.passwordResetEmailSent,
                                        buttonText: local.close,
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;

                                      CustomDialog.showError(
                                        context: context,
                                        message: e.toString(),
                                        buttonText: local.close,
                                      );
                                    } finally {
                                      if (mounted) {
                                        setState(() {
                                          _isResettingPassword = false;
                                        });
                                      }
                                    }
                                  },
                                  child: Text(
                                    local.resetPassword,
                                    style: AppStyles.regular16White,
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Delete Account
                              ElevatedButtonReuse(
                                background: AppColors.red,
                                onPressed: isUpdating
                                    ? () {}
                                    : () {
                                  _confirmDeleteAccount(
                                    context,
                                    local,
                                    cubit,
                                  );
                                },
                                childType: Text(
                                  local.deleteAccount,
                                  style: AppStyles.bold20White,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Update Profile
                              ElevatedButtonReuse(
                                background: AppColors.yellow,
                                onPressed: isUpdating
                                    ? () {}
                                    : () {
                                  if (_formKey.currentState!
                                      .validate()) {
                                    cubit.updateProfile(
                                      name: _nameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      avatarId: _selectedAvatarId,
                                    );
                                  }
                                },
                                childType: isUpdating
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

  void _confirmDeleteAccount(BuildContext context,
      AppLocalizations local,
      ProfileCubit cubit,) {
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
