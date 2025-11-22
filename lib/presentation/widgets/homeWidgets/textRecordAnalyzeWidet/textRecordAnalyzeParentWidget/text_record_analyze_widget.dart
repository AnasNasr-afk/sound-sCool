import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';
import '../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../helpers/color_manager.dart';
import '../widgets/components/stage_indicator_row.dart';
import '../widgets/stages/text_analyze_stage.dart';
import '../widgets/stages/text_recording_stage.dart';
import '../widgets/stages/text_generating_stage.dart';

class TextRecordAnalyzeWidget extends StatelessWidget {
  const TextRecordAnalyzeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        width: double.infinity,
        // Set a fixed or constrained height instead of expanding
        constraints: BoxConstraints(
          minHeight: 300.h,
          maxHeight: 500.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: ColorManager.mainGrey.withValues(alpha: 0.3),
            width: 1.2.w,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.darkGrey.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              "Practice Session",
              style: TextStyles.font14DarkGreyRegular,
            ),
            SizedBox(height: 12.h),
            BlocBuilder<HomeCubit, HomeStates>(
              builder: (context, state) {
                final cubit = HomeCubit.get(context);
                return StageIndicatorRow(currentStage: cubit.currentStage);
              },
            ),
            SizedBox(height: 16.h),
            // Use Flexible or constrain the height instead of Expanded
            Flexible(
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  final cubit = HomeCubit.get(context);
                  if (cubit.currentStage == Stage.analyze) {
                    return const TextAnalyzeStage();
                  } else if (cubit.currentStage == Stage.record) {
                    return const TextRecordingStage();
                  }
                  return const TextGeneratingStage();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}