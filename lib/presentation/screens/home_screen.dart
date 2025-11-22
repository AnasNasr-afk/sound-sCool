import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/homeWidgets/connectivity_listener.dart';
import '../../business_logic/homeCubit/home_cubit.dart';
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

  Future<void> _handleRefresh() async {
    // Reload session stats when user pulls to refresh
    await context.read<HomeCubit>().loadSessionStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: Colors.blueAccent, // Use your app's primary color
          backgroundColor: Colors.white,
          strokeWidth: 3.0,
          displacement: 40.0, // Better visual spacing
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Your existing content
                  HomeScreenHeader(),
                  SizedBox(height: 16.h),
                  LearningProgress(),
                  SizedBox(height: 16.h),
                  SelectLanguage(),
                  SizedBox(height: 16.h),
                  TextRecordAnalyzeWidget(),

                  ConnectivityListener(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}