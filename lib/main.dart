import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/routing/app_router.dart';
import 'package:sounds_cool/routing/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  // Use Firebase Auth instead of SharedPreferences for initial check
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final bool isLoggedIn = currentUser != null;

  debugPrint('🔥 Firebase Auth user: ${currentUser?.uid ?? "No user"}');
  debugPrint('📱 Login status: $isLoggedIn');

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
      ),
    );
  }
}