import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/color_manager.dart';
import '../../../../helpers/text_styles.dart';



class SessionHeader extends StatelessWidget {
  final VoidCallback onAddText;

  const SessionHeader({
    super.key,
    required this.onAddText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Recent Sessions',
          style: TextStyles.font14GreyRegular.copyWith(
            color: ColorManager.mainBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onAddText,
          style: TextButton.styleFrom(
            backgroundColor: ColorManager.mainGreen.withValues(alpha: 0.08),
            foregroundColor: ColorManager.mainGreen,
            padding: EdgeInsets.symmetric(
              horizontal: 6.w,
              vertical: 6.h,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
              side: BorderSide(
                color: ColorManager.mainGreen.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add your text',
                style: TextStyles.font12GreenMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(width: 6.w),
              Icon(
                Icons.add_circle_rounded,
                size: 16.sp,
                color: ColorManager.mainGreen,
              ),
            ],
          ),
        ),
      ],
    );
  }
}