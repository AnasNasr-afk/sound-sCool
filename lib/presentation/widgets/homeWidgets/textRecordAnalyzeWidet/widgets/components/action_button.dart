import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/text_styles.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color? backgroundColor;

  const ActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bool useGradient = backgroundColor == null;

    return Container(
      width: double.infinity.w,
      height: 50.h,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: ColorManager.mainBlack.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        gradient: useGradient
            ? LinearGradient(
          colors: [
            ColorManager.gradientLightDark,
            ColorManager.mainGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        color: useGradient ? null : backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: icon != null
          ? TextButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 18.sp,
          color: ColorManager.whiter,
        ),
        label: Text(
          label,
          style: TextStyles.font16BlackSemiBold.copyWith(
            color: ColorManager.whiter,
            fontSize: 14.sp,
          ),
        ),
        style: ButtonStyle(
          overlayColor:
          WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      )
          : TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          overlayColor:
          WidgetStatePropertyAll(Colors.transparent),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
        child: Text(
          label,
          style: TextStyles.font16BlackSemiBold.copyWith(
            color: ColorManager.whiter,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}
