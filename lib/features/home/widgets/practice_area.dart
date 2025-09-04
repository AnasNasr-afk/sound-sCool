import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/color_manager.dart';
import 'text_generator.dart';

class PracticeArea extends StatefulWidget {
  const PracticeArea({super.key});

  @override
  State<PracticeArea> createState() => _PracticeAreaState();
}

class _PracticeAreaState extends State<PracticeArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: ColorManager.mainGrey.withValues(alpha:0.6),
            blurRadius: 12,
            offset: const Offset(9, 9),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Session',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: ColorManager.mainBlack,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Add text logic
                },
                child: Container(
                  height: 36.h,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.add,
                          color: ColorManager.primaryColor, size: 18.w),
                      SizedBox(width: 6.w),
                      Text(
                        'Add Text',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),

          /// Body: text generator widget
          const Expanded(child: TextGeneratorWidget()),
        ],
      ),
    );
  }
}
