import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';
import '../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../helpers/color_manager.dart';
import '../widgets/components/stage_indicator_row.dart';
import '../widgets/stages/text_analyze_stage.dart';
import '../widgets/stages/text_generating_stage.dart';
import '../widgets/stages/text_recording_stage.dart';






class TextRecordAnalyzeWidget extends StatelessWidget {
  const TextRecordAnalyzeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.darkGrey.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Practice Session",
                style: TextStyles.font16BlackSemiBold,
              ),
              SizedBox(height: 12.h),

              // Progress Row with dynamic stage indicators
              BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  final cubit = HomeCubit.get(context);
                  return StageIndicatorRow(currentStage: cubit.currentStage);
                },
              ),

              SizedBox(height: 16.h),

              // Stage content goes here 👇
              // Stage content goes here 👇
              Expanded(
                child: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    final cubit = HomeCubit.get(context);

                    if (cubit.currentStage == Stage.analyze) {
                      return const TextAnalyzeStage();
                    } else if (cubit.currentStage == Stage.record) {
                      return const TextRecordingStage();
                    }

                    // default to generate stage
                    return const TextGeneratingStage();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


