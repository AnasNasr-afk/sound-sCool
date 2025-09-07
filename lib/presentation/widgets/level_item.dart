import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';


class LevelItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const LevelItem({
    super.key,
    required this.text,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 30.h,
        decoration: BoxDecoration(
          color: isSelected ? ColorManager.mainGreen : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.darkGrey.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white, width: 1.5.w)
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyles.font10BlackSemiBold.copyWith(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
