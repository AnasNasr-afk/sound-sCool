import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../business_logic/homeCubit/home_cubit.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class RecordingView extends StatelessWidget {
  final HomeCubit cubit;
  final String? timeDisplay;

  const RecordingView({
    super.key,
    required this.cubit,
    this.timeDisplay,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show the text being practiced
          if (cubit.displayedText != null) ...[
            Text(
              cubit.displayedText!,
              style: TextStyles.font14GreyRegular.copyWith(
                fontSize: 15.sp,
                height: 1.8,
                color: ColorManager.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
          ],

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red recording dot
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),

                // Timer display
                Text(
                  timeDisplay ?? '0:00 / 0:30',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),

                // "FREE" label
                Text(
                  'FREE',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecordingCompleteView extends StatelessWidget {
  final HomeCubit cubit;

  const RecordingCompleteView({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: ColorManager.mainGreen,
            size: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'Recording Complete!',
            style: TextStyles.font14GreyRegular.copyWith(
              color: ColorManager.mainGreen,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Processing your pronunciation...',
            style: TextStyles.font14GreyRegular.copyWith(
              color: ColorManager.darkGrey,
              fontSize: 13.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => cubit.retryPronunciation(),
                icon: Icon(Icons.refresh, size: 16.sp),
                label: const Text('Try Again'),
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.mainGreen,
                ),
              ),
              TextButton.icon(
                onPressed: () => cubit.startNewSession(),
                icon: Icon(Icons.add, size: 16.sp),
                label: const Text('New Text'),
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.mainGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecordingCancelledView extends StatelessWidget {
  final HomeCubit cubit;

  const RecordingCancelledView({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (cubit.displayedText != null) ...[
            Text(
              cubit.displayedText!,
              style: TextStyles.font14GreyRegular.copyWith(
                fontSize: 15.sp,
                height: 1.8,
                color: ColorManager.darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
          ],
          Icon(
            Icons.cancel_outlined,
            color: ColorManager.darkGrey,
            size: 32.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            'Recording Cancelled',
            style: TextStyles.font14GreyRegular.copyWith(
              color: ColorManager.darkGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}