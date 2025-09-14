import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/recentSessionWidgets/session_body_content.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/recentSessionWidgets/session_header.dart';

import '../../../../helpers/color_manager.dart';


class RecentSession extends StatelessWidget {
  const RecentSession({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.darkGrey.withValues(alpha: 0.15),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SessionHeader(
                onAddText: () {
                  // TODO: Implement custom text input
                },
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.mainGrey.withValues(alpha: 0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.darkGrey.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const SessionBodyContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}