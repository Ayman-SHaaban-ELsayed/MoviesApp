import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/size_utils.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/custom_text_form_field.dart';
import '../widgets/elevated_button_reuse.dart';
import 'forgot_password_cubit.dart';
import 'forgot_password_states.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final local = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(),
      child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccessState) {
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
              message: local.passwordResetEmailSent,
              buttonText: local.close,
            ).then((_) => navigateBack());

            Future.delayed(const Duration(milliseconds: 900), navigateBack);
          } else if (state is ForgotPasswordErrorState) {
            CustomDialog.showError(
              context: context,
              message: _getLocalizedError(state.errorMessage, local),
              buttonText: local.close,
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<ForgotPasswordCubit>();
          final isLoading = state is ForgotPasswordLoadingState;

          return Scaffold(
            backgroundColor: AppColors.primary,
            appBar: AppBar(
              backgroundColor: AppColors.primary,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.yellow),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: width * .06),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * .02),

                      // ——— Illustration ———
                      Center(
                        child: Image.asset(
                          AppAssets.forgotPassword,
                          height: height * .30,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: height * .04),

                      // ——— Title ———
                      Text(
                        local.forgetPassword,
                        style: AppStyles.bold24White,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * .012),

                      // ——— Subtitle ———
                      Text(
                        local.passwordResetEmailSent
                            .replaceAll(RegExp(r'A password.*'), '')
                            .trim()
                            .isEmpty
                            ? 'Enter your email and we\'ll send you a link to reset your password.'
                            : 'Enter your email and we\'ll send you a link to reset your password.',
                        style: AppStyles.regular16White.copyWith(
                          color: AppColors.white.withValues(alpha: .65),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * .04),

                      // ——— Email Field ———
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
                      SizedBox(height: height * .04),

                      // ——— Send Reset Link Button ———
                      ElevatedButtonReuse(
                        background: AppColors.yellow,
                        onpressed: isLoading
                            ? () {}
                            : () {
                                if (formKey.currentState!.validate()) {
                                  cubit.sendResetLink(
                                    email: emailController.text,
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
                                local.sendResetLink,
                                style: AppStyles.bold20Black,
                              ),
                      ),
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

  String _getLocalizedError(String error, AppLocalizations local) {
    if (error.contains('No account') || error.contains('user-not-found')) {
      return local.userNotFound;
    }
    if (error.contains('internet') || error.contains('network')) {
      return local.noInternetConnection;
    }
    if (error.contains('attempts') || error.contains('too-many-requests')) {
      return local.tooManyRequests;
    }
    return local.somethingWentWrong;
  }
}
