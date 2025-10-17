import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../business_logic/homeCubit/home_cubit.dart';
import '../../../business_logic/homeCubit/home_states.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class LearningProgress extends StatelessWidget {
  const LearningProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _MonthlySession(
                title: 'This Month',
                value: '${cubit.monthlyCompletedSessions} sessions',
                icon: Icons.trending_up_rounded,
                iconColor: ColorManager.mainGreen,
              ),

              _DailyLimit(
                icon: Icons.text_fields_rounded,
                value: '${cubit.dailyGenerations}/7',
                label: 'FREE',
              ),

              _DailyLimit(
                icon: Icons.mic_rounded,
                value: '${cubit.dailyRecordings}/7',
                label: 'FREE',
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MonthlySession extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;

  const _MonthlySession({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24.w,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyles.font14GreyRegular),
              Text(
                value,
                style: TextStyles.font20BlackBold.copyWith(fontSize: 16.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DailyLimit extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _DailyLimit({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 72.w,
      padding: EdgeInsets.symmetric(vertical: 5.h),
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16.r,
            backgroundColor: ColorManager.mainGreen.withValues(alpha: 0.15),
            child: Icon(icon, color: ColorManager.mainGreen, size: 18.w),
          ),
          SizedBox(height: 6.h),
          Text(value, style: TextStyles.font10BlackSemiBold),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyles.font10BlackSemiBold.copyWith(
              color: ColorManager.mainGreen,
              fontSize: 8.sp,
            ),
          ),
        ],
      ),
    );
  }
}