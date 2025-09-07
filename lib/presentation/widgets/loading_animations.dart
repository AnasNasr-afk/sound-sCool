import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';

Widget buildLoadingAnimation() {
  return Center(
    key: const ValueKey('loading'),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pulsing circle animation (iOS-like)
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.8, end: 1.2),
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Container(
                width: 70.w,
                height: 70.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      ColorManager.mainGreen.withValues(alpha: 0.5),
                      ColorManager.mainGreen,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.mainGreen.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: CupertinoActivityIndicator(radius: 14), // iOS style
                ),
              ),
            );
          },
          onEnd: () {
            // Repeat indefinitely
          },
        ),
        SizedBox(height: 20.h),

        // Subtle animated text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: Text(
            "Generating your text...",
            key: ValueKey(DateTime.now().second % 2), // triggers fade
            style: TextStyles.font14GreyRegular.copyWith(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: ColorManager.darkGrey,
            ),
          ),
        ),
      ],
    ),
  );
}
