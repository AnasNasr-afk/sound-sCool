import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';


class LanguageItem extends StatelessWidget {
  final String text;
  final String assetPath;
  final bool isSelected;
  final VoidCallback? onTap;

  const LanguageItem({
    super.key,
    required this.text,
    required this.assetPath,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: ColorManager.darkGrey.withValues(alpha: 0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: isSelected
              ? Border.all(color: ColorManager.mainGreen, width: 1.5.w)
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(assetPath, width: 28.w, height: 28.h),
            Text(text, style: TextStyles.font10BlackSemiBold),
          ],
        ),
      ),
    );
  }
}
