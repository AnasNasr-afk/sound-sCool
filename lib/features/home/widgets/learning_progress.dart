import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/color_manager.dart';

class LearningProgress extends StatelessWidget {
  const LearningProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorManager.mainGrey.withValues(alpha: 0.9),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'This Month',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: ColorManager.darkGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '12 sessions',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.mainBlack,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(
              Icons.trending_up,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ],
      ),
    );
  }
}
