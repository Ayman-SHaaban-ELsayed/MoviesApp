import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/auth/register/cubit/register_cubit.dart';
import 'package:movies_app/ui/auth/register/cubit/register_states.dart';
import 'package:movies_app/ui/widgets/custom_dialog.dart';
import 'package:movies_app/ui/widgets/custom_text_form_field.dart';
import 'package:movies_app/ui/widgets/elevated_button_reuse.dart';
import 'package:movies_app/ui/widgets/language_switch_widget.dart';
import 'package:movies_app/utils/app_assets.dart';
import 'package:movies_app/utils/app_colors.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/app_styles.dart';
import 'package:movies_app/utils/app_validator.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';
import 'package:movies_app/utils/size_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController(text: 'samih asaad tawfeek');
  final emailController = TextEditingController(text: 'sam@gmail.com');
  final passwordController = TextEditingController(text: 'Ss12345678#');
  final rePasswordController = TextEditingController(text: 'Ss12345678#');
  final phoneController = TextEditingController(text: '01221952339');
  final formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isRePasswordVisible = false;

  late final PageController _avatarPageController;
  int _currentPage = 0;

  static const List<String> _avatarAssets = [
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

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _avatarPageController = PageController(
      initialPage: 0,
      viewportFraction: 0.38,
    );
  }

  @override
  void dispose() {
    _avatarPageController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            SharedPrefUtils.saveUserId(state.user.id);
            SharedPrefUtils.saveOnboardingSeen(true);
            bool navigated = false;
            void navigateHome() {
              if (!navigated && context.mounted) {
                navigated = true;
                CustomDialog.hide(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.homeRouteName,
                  (route) => false,
                );
              }
            }

            CustomDialog.showSuccess(
              context: context,
              message: local.registerSuccess,
              buttonText: local.close,
            ).then((_) => navigateHome());

            Future.delayed(const Duration(milliseconds: 900), navigateHome);
          } else if (state is RegisterErrorState) {
            CustomDialog.showError(
              context: context,
              message: _getLocalizedErrorMessage(state.errorMessage, local),
              buttonText: local.close,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();
          final isLoading = state is RegisterLoadingState;

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
              title: Text(local.register, style: AppStyles.regular16Yellow),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * .05),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * .015),

                      SizedBox(
                        height: height * .16,
                        child: PageView.builder(
                          controller: _avatarPageController,
                          itemCount: _avatarAssets.length,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                            cubit.changeAvatar(index + 1);
                          },
                          itemBuilder: (context, index) {
                            final isCenter = index == _currentPage;
                            return Center(
                              child: GestureDetector(
                                onTap: () {
                                  _avatarPageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  width: isCenter ? height * .15 : height * .10,
                                  height: isCenter
                                      ? height * .15
                                      : height * .10,
                                  child: Image.asset(
                                    _avatarAssets[index],
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: height * .008),

                      Center(
                        child: Text('Avatar', style: AppStyles.regular16White),
                      ),
                      SizedBox(height: height * .02),

                      CustomTextFormField(
                        controller: nameController,
                        fill: true,
                        filledColor: AppColors.darkGrey,
                        hintText: local.name,
                        hintStyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        curserColor: AppColors.yellow,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.nameIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        validator: (text) =>
                            AppValidators.validateName(text),
                      ),
                      SizedBox(height: height * .018),

                      CustomTextFormField(
                        controller: emailController,
                        fill: true,
                        filledColor: AppColors.darkGrey,
                        hintText: local.email,
                        hintStyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        curserColor: AppColors.yellow,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.emailIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        validator: (text) => AppValidators.validateEmail(text!.trim()),
                      ),
                      SizedBox(height: height * .018),

                      CustomTextFormField(
                        controller: passwordController,
                        fill: true,
                        filledColor: AppColors.darkGrey,
                        hintText: local.password,
                        hintStyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        curserColor: AppColors.yellow,
                        obscureText: !_isPasswordVisible,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.passwordIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        validator: (text) =>
                            AppValidators.validatePassword(text),
                      ),
                      SizedBox(height: height * .018),

                      CustomTextFormField(
                        controller: rePasswordController,
                        fill: true,
                        filledColor: AppColors.darkGrey,
                        hintText: local.confirmPassword,
                        hintStyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        curserColor: AppColors.yellow,
                        obscureText: !_isRePasswordVisible,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.passwordIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRePasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRePasswordVisible = !_isRePasswordVisible;
                            });
                          },
                        ),
                        validator: (text) =>
                            AppValidators.validateConfirmPassword(
                              text,
                              passwordController.text,
                            ),
                      ),

                      SizedBox(height: height * .018),

                      CustomTextFormField(
                        controller: phoneController,
                        fill: true,
                        filledColor: AppColors.darkGrey,
                        hintText: local.phoneNumber,
                        hintStyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        curserColor: AppColors.yellow,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.phoneIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        validator: (text) =>
                            AppValidators.validatePhoneNumber(text!.trim()),
                      ),

                      SizedBox(height: height * .03),

                      ElevatedButtonReuse(
                        background: AppColors.yellow,
                        onpressed: isLoading
                            ? () {}
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.register(
                                    name: nameController.text,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                        ChildType: isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                ),
                              )
                            : Text(
                                local.createAccount,
                                style: AppStyles.bold20Black,
                              ),
                      ),
                      SizedBox(height: height * .02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${local.alreadyHaveAccount} ',
                            style: AppStyles.regular14White,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Text(
                              local.login,
                              style: AppStyles.bold14Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),

                      const Center(child: LanguageSwitchWidget()),
                      SizedBox(height: height * .03),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getLocalizedErrorMessage(
    String error,
    AppLocalizations localizations,
  ) {
    if (error.contains('email-already-in-use') ||
        error.contains('already exists')) {
      return localizations.emailAlreadyInUse;
    }
    if (error.contains('invalid-email')) {
      return localizations.emailInvalid;
    }
    if (error.contains('weak-password')) {
      return localizations.passwordRequired;
    }
    if (error.contains('internet') || error.contains('network')) {
      return localizations.noInternetConnection;
    }
    return error;
  }
}
