import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/auth/login/cubit/login_cubit.dart';
import 'package:movies_app/ui/auth/login/cubit/login_states.dart';
import 'package:movies_app/ui/auth/register/register_Screen.dart';
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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccessState) {
            SharedPrefUtils.saveUserId(state.user.id);
            SharedPrefUtils.saveOnboardingSeen(true);
            bool navigated = false;
            void navigateHome() {
              if (!navigated && context.mounted) {
                navigated = true;
                CustomDialog.hide(context);
                Navigator.pushReplacementNamed(context, AppRoutes.homeRouteName);
              }
            }

            CustomDialog.showSuccess(
              context: context,
              message: '${local.welcome}, ${state.user.name}!',
              buttonText: local.close,
            ).then((_) => navigateHome());

            Future.delayed(const Duration(milliseconds: 900), navigateHome);
          } else if (state is LoginErrorState) {
            CustomDialog.showError(
              context: context,
              message: _getLocalizedErrorMessage(state.errorMessage, local),
              buttonText: local.close,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<LoginCubit>();
          final isNormalLoading = state is LoginLoadingState;
          final isGoogleLoading = state is GoogleLoginLoadingState;
          final isAnyLoading = isNormalLoading || isGoogleLoading;
          return Scaffold(
            backgroundColor: AppColors.primary,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * .05),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * .03),

                      Center(
                        child: Image.asset(
                          AppAssets.appLogo,
                          height: height * .16,
                        ),
                      ),
                      SizedBox(height: height * .05),

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
                        validator: (text) =>AppValidators.validateEmail(text),
                      ),
                      SizedBox(height: height * .02),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return CustomTextFormField(
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
                            obscureText: !cubit.isPasswordVisible,
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
                                cubit.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.white,
                              ),
                              onPressed: cubit.togglePasswordVisibility,
                            ),
                            validator: (text) =>AppValidators.validatePassword(text),
                          );
                        },
                      ),

                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordRouteName,
                          ),
                          child: Text(
                            local.forgetPasswordQuestion,
                            style: AppStyles.regular14White.copyWith(
                              color: AppColors.yellow,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * .02),

                      ElevatedButtonReuse(
                        background: AppColors.yellow,
                        onPressed: isAnyLoading
                            ? () {}
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.login(
                                    email: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              },
                        childType: isNormalLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: AppColors.primary,
                                ),
                              )
                            : Text(
                                local.login,
                          style: AppStyles.regular20Black,
                              ),
                      ),
                      SizedBox(height: height * .025),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${local.dontHaveAccount} ',
                            style: AppStyles.regular14White,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            ),
                            child: Text(
                              local.createOne,
                              style: AppStyles.bold14Yellow,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,

                              indent: width * .06,

                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * .04),
                            child: Text(
                              local.or,
                              style: AppStyles.regular16Yellow,
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
                              endIndent: width * .06,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),

                      ElevatedButtonReuse(
                        background: AppColors.yellow,
                        onPressed: isAnyLoading
                            ? () {}
                            : () => cubit.signInWithGoogle(),
                        childType:
                        isGoogleLoading
                            ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.primary,
                          ),
                        )
                            :
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.googleLogo,
                              width: 24,
                              height: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              local.loginWithGoogle,
                              style: AppStyles.regular16Black,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: height * .035),

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
      String error, AppLocalizations localizations) {
    if (error.contains('Incorrect') ||
        error.contains('invalid-credential') ||
        error.contains('wrong-password') ||
        error.contains('user-not-found')) {
      return localizations.invalidCredentials;
    }
    if (error.contains('internet') || error.contains('network')) {
      return localizations.noInternetConnection;
    }
    if (error.contains('attempts') || error.contains('too-many-requests')) {
      return localizations.tooManyRequests;
    }
    return error;
  }
}