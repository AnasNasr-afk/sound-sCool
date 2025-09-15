import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/routing/app_router.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(SoundsCoolApp(appRouter: AppRouter()));
}


class SoundsCoolApp extends StatelessWidget {
  final AppRouter appRouter;
  const SoundsCoolApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Sounds Cool',
        debugShowCheckedModeBanner: false,
       onGenerateRoute: appRouter.onGenerateRoute,
      ),
    );
  }
}




