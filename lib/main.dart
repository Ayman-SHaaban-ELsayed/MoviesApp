import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/forgot_password/forgot_password_screen.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/login/login_Screen.dart';
import 'package:movies_app/ui/register/register_Screen.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/locale_cubit.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // تحديد أول شاشة بناءً على حالة تسجيل الدخول المحفوظة
    final bool isLoggedIn = SharedPrefUtils.userId != null &&
        SharedPrefUtils.userId!.isNotEmpty;
    final String initialRoute = isLoggedIn
        ? AppRoutes.homeRouteName
        : AppRoutes.loginRouteName;

    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale?>(
        builder: (context, locale) {
          return MaterialApp(
            title: 'Movies',
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            routes: {
              AppRoutes.homeRouteName: (context) => const HomeScreen(),
              AppRoutes.loginRouteName: (context) => const LoginScreen(),
              AppRoutes.registerRouteName: (context) => const RegisterScreen(),
              AppRoutes.forgotPasswordRouteName: (context) =>
                  const ForgotPasswordScreen(),
            },
          );
        },
      ),
    );
  }
}
