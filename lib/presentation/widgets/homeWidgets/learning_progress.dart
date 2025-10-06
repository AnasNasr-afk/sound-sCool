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
                      offset: const Offset(1, 3),
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
                        Text('${cubit.completedSessions} sessions',
                            style: TextStyles.font20BlackBold),
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
                      offset: const Offset(1, 3),
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
                        size: 23.w,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${cubit.totalRecordings}/7',
                            style: TextStyles.font10BlackSemiBold),
                        SizedBox(width: 4.w),
                        Text('FREE', style: TextStyles.font10BlackSemiBold),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}