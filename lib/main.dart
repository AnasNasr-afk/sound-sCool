import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/color_manager.dart';

import 'features/home/home_screen.dart';

void main() {
  runApp(const SoundsCoolApp());
}


class SoundsCoolApp extends StatelessWidget {
  const SoundsCoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp(
        title: 'Sounds Cool',
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}




