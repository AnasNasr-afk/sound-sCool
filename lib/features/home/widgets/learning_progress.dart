import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/color_manager.dart';

import '../../../core/theming/text_styles.dart';

class LearningProgress extends StatelessWidget {
  const LearningProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 230.w,
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorManager.darkGrey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('This Month', style: TextStyles.font14GreyRegular),
                    Text('12 sessions', style: TextStyles.font20BlackBold),
                  ],
                ),
                Spacer(),
                Icon(
                  Icons.trending_up,
                  shadows: [
                    Shadow(
                      color: ColorManager.darkGrey.withValues(alpha: 0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: ColorManager.mainGreen,
                  size: 32.w,
                ),

                // CircleAvatar(
                //
                //   radius: 24.r,
                //   backgroundColor: ColorManager.mainGreen,
                //   child: Icon(Icons.trending_up,
                //       // shadows: [
                //       //   Shadow(
                //       //     color: ColorManager.darkGrey.withValues(alpha: 0.3),
                //       //     blurRadius: 5,
                //       //     offset: const Offset(0, 3),
                //       //   ),
                //       // ],
                //       color: Colors.white, size: 32.w),
                // ),
              ],
            ),
          ),
          Container(
            width: 80.w,
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: ColorManager.darkGrey.withValues(alpha: 0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(1, 3), // changes position of shadow
                ),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: ColorManager.mainGreen,
                      child: Icon(
                        Icons.mic,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: ColorManager.darkGrey.withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                        size: 23.w,
                      ),
                    ),
                SizedBox(height: 6.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('1/7',
                        style: TextStyles.font10BlackSemiBold,
                    ),
                    SizedBox(width: 4.w),
                    Text('FREE' ,
                        style: TextStyles.font10BlackSemiBold
                    )
                  ],
                )

              ],
            ),
          ),
        ],
      ),
    );
  }
}
