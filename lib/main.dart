import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/firebase_options.dart';
import 'package:movies_app/l10n/app_localizations.dart';
import 'package:movies_app/ui/auth/forgot_password/forgot_password_screen.dart';
import 'package:movies_app/ui/auth/login/login_Screen.dart';
import 'package:movies_app/ui/auth/register/register_Screen.dart';
import 'package:movies_app/ui/home/home_screen.dart';
import 'package:movies_app/ui/home/tab_list/profile_tab/update_profile_screen.dart';
import 'package:movies_app/ui/onBoarding/onBoarding_screen.dart';
import 'package:movies_app/utils/app_routes.dart';
import 'package:movies_app/utils/locale_cubit.dart';
import 'package:movies_app/utils/shared_pref_utils.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefUtils.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final String? savedUserId = SharedPrefUtils.userId;
    final bool isLoggedIn =
        (savedUserId != null && savedUserId.isNotEmpty) ||
        (currentUser != null);

    if (isLoggedIn &&
        (savedUserId == null || savedUserId.isEmpty) &&
        currentUser != null) {
      SharedPrefUtils.saveUserId(currentUser.uid);
    }

    final String initialRoute;
    if (isLoggedIn) {
      initialRoute = AppRoutes.homeRouteName;
    } else if (SharedPrefUtils.isOnboardingSeen) {
      initialRoute = AppRoutes.loginRouteName;
    } else {
      initialRoute = AppRoutes.onBoardingRouteName;
    }

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
              AppRoutes.onBoardingRouteName: (context) =>
                  const OnBoardingScreen(),
              AppRoutes.registerRouteName: (context) => const RegisterScreen(),
              AppRoutes.forgotPasswordRouteName: (context) =>
                  const ForgotPasswordScreen(),
              AppRoutes.updateProfileRouteName: (context) =>
                  const UpdateProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
