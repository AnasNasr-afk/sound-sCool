import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../widgets/debug_info_widget.dart';
import '../widgets/debug_stop_button.dart';
import '../widgets/home_floating_action_button.dart';
import '../widgets/home_screen_header.dart';
import '../widgets/learning_progress.dart';
import '../widgets/recentSession/recent_session.dart';
import '../widgets/select_language.dart';

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
      floatingActionButton: const HomeFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Column(
            children: [
              // Layer 1: Header
              HomeScreenHeader(),
              SizedBox(height: 20.h),
              // const DebugInfoWidget(),
              // Layer 2
              LearningProgress(),
              SizedBox(height: 20.h),
              // Layer 3
              SelectLanguage(),
              SizedBox(height: 20.h),


              // Layer 4
              RecentSession(),


            ],
          ),
        ),
      ),
    );
  }
}
