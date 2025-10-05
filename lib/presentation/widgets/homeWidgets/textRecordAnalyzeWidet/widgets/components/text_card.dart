import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/text_styles.dart';

class TextCard extends StatelessWidget {
  final String text;

  const TextCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: ColorManager.mainGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.mainGreen.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyles.font14GreyRegular,
      ),
    );
  }
}
