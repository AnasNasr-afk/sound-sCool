import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/color_manager.dart';
import 'package:sounds_cool/features/home/widgets/home_screen_header.dart';
import 'package:sounds_cool/features/home/widgets/language_selection.dart';
import 'package:sounds_cool/features/home/widgets/learning_progress.dart';
import 'package:sounds_cool/features/home/widgets/practice_area.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            children: [
              // Layer 1: Header
              HomeScreenHeader(),
              SizedBox(height: 20.h),
              //layer 2
              LearningProgress(),
              SizedBox(height: 20.h),
              //layer 3
              LanguageSelection(),
              SizedBox(height: 20.h),

              //layer 4
              Expanded(child:PracticeArea()),

              // // Layer 2: Learning Progress
              // LearningProgress(),
              // const SizedBox(height: 24),
              //
              // // Layer 3: Language & Level Selection
              // LanguageSelection(),
              // const SizedBox(height: 32),
              //
              // Expanded(child:PracticeArea()),
            ],
          ),
        ),
      ),
    );
  }


}