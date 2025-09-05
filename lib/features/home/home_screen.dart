import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/color_manager.dart';
import 'package:sounds_cool/features/home/widgets/home_screen_header.dart';
import 'package:sounds_cool/features/home/widgets/select_language.dart';
import 'package:sounds_cool/features/home/widgets/learning_progress.dart';
import 'package:sounds_cool/features/home/widgets/recent_session.dart';

import '../../core/theming/text_styles.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor2,


      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric( vertical: 5.h),
          child: Column(
            children: [
              // Layer 1: Header
              HomeScreenHeader(),
              SizedBox(height: 20.h),
              //layer 2
              LearningProgress(),
              SizedBox(height: 20.h),
              //layer 3
              SelectLanguage(),
              SizedBox(height: 20.h),

              //layer 4
              RecentSession(),

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