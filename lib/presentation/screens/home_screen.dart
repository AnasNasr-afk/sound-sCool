import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../business_logic/homeCubit/home_cubit.dart';
import '../../helpers/color_manager.dart';

import '../widgets/homeWidgets/home_screen_header.dart';
import '../widgets/homeWidgets/learning_progress.dart';

import '../widgets/homeWidgets/select_language.dart';
import '../widgets/homeWidgets/textRecordAnalyzeWidet/textRecordAnalyzeParentWidget/text_record_analyze_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadSessionStats();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.backgroundColor2,
      // floatingActionButton: const HomeFloatingActionButton(),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
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
              TextRecordAnalyzeWidget(),


            ],
          ),
        ),
      ),
    );
  }
}
