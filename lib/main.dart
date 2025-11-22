
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/color_manager.dart';
import 'package:sounds_cool/routing/app_router.dart';
import 'package:sounds_cool/routing/routes.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final bool isLoggedIn = currentUser != null;

  runApp(
    SoundsCoolApp(
      appRouter: AppRouter(),
      isLoggedIn: isLoggedIn,
    ),
  );
}

class SoundsCoolApp extends StatelessWidget {
  final AppRouter appRouter;
  final bool isLoggedIn;

  const SoundsCoolApp({
    super.key,
    required this.appRouter,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Sounds Cool',
        debugShowCheckedModeBanner: false,
        initialRoute: isLoggedIn ? Routes.homeScreen : Routes.authScreen,
        onGenerateRoute: appRouter.onGenerateRoute,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorManager.backgroundColor2),
          // scaffoldBackgroundColor: ColorManager.backgroundColor2,
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: ColorManager.mainBlack,
            selectionColor: ColorManager.mainBlack.withValues(alpha: 0.25),
            selectionHandleColor: ColorManager.mainBlack,
          ),
        ),
      ),
    );
  }
}
