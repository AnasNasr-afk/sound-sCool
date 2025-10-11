import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/business_logic/authCubit/auth_cubit.dart';
import 'package:sounds_cool/business_logic/settingsCubit/settings_cubit.dart';
import 'package:sounds_cool/data/networking/api_service.dart';
import 'package:sounds_cool/data/networking/user_limits_service.dart';
import 'package:sounds_cool/routing/routes.dart';

import '../business_logic/homeCubit/home_cubit.dart';
import '../presentation/screens/auth_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/settings_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => HomeCubit(
              ApiService(),
              UserLimitsService(),
              FirebaseAuth.instance.currentUser!.uid,
            ),
            child: HomeScreen(),
          ),
        );
      case Routes.authScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: AuthScreen(),
          ),
        );
      case Routes.settingsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => BlocProvider(
            create: (_) => SettingsCubit(),
            child: const SettingsScreen(),
          ),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
