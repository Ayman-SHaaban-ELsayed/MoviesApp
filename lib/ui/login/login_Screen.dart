import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_routes.dart';
import '../../utils/app_styles.dart';
import '../../utils/shared_pref_utils.dart';
import '../../utils/size_utils.dart';
import '../register/register_Screen.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/elevated_button_reuse.dart';
import '../widgets/language_switch_widget.dart';
import 'login_cubit.dart';
import 'login_states.dart';

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
          final isLoading = state is LoginLoadingState;

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

                      // ——— App Logo ———
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
                        hinttext: local.email,
                        hintstyle: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .7),
                        ),
                        style: AppStyles.regular16White,
                        borderColor: AppColors.darkGrey,
                        cursercolor: AppColors.yellow,
                        keyboradtype: TextInputType.emailAddress,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Image.asset(
                            AppAssets.emailIcon,
                            width: 20,
                            height: 20,
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.trim().isEmpty) {
                            return local.emailRequired;
                          }
                          final isValid = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          ).hasMatch(text.trim());
                          if (!isValid) return local.emailInvalid;
                          return null;
                        },
                      ),
                      SizedBox(height: height * .02),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return CustomTextFormField(
                            controller: passwordController,
                            fill: true,
                            filledColor: AppColors.darkGrey,
                            hinttext: local.password,
                            hintstyle: AppStyles.regular16White.copyWith(
                              color: AppColors.white.withValues(alpha: .7),
                            ),
                            style: AppStyles.regular16White,
                            borderColor: AppColors.darkGrey,
                            cursercolor: AppColors.yellow,
                            obscuretext: !cubit.isPasswordVisible,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Image.asset(
                                AppAssets.passwordIcon,
                                width: 20,
                                height: 20,
                              ),
                            ),
                            sufixIcon: IconButton(
                              icon: Icon(
                                cubit.isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.white,
                              ),
                              onPressed: cubit.togglePasswordVisibility,
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return local.passwordRequired;
                              }
                              if (text.length < 6) {
                                return local.passwordRequired;
                              }
                              return null;
                            },
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
                        onpressed: isLoading
                            ? () {}
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.login(
                                    email: emailController.text,
                                    password: passwordController.text,
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
                                local.login,
                                style: AppStyles.bold20Black,
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
                          const Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
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
                          const Expanded(
                            child: Divider(
                              color: AppColors.yellow,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * .025),

                      ElevatedButtonReuse(
                        background: AppColors.yellow,
                        onpressed: isLoading
                            ? () {}
                            : () => cubit.signInWithGoogle(),
                        ChildType: Row(
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
                              style: AppStyles.bold16Black,
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