import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/data/networking/api_service.dart';
import 'package:sounds_cool/routing/routes.dart';

import '../business_logic/homeCubit/home_cubit.dart';
import '../presentation/screens/home_screen.dart';


class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => BlocProvider(
            create: (context) => HomeCubit(ApiService()),
            child: HomeScreen()));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}