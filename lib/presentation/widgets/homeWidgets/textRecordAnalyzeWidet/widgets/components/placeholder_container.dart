import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';
import 'package:sounds_cool/helpers/color_manager.dart';

class PlaceholderContainer extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const PlaceholderContainer({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.sp, color: ColorManager.mainGrey),
          SizedBox(height: 16.h),
          Text(title, style: TextStyles.font16BlackSemiBold.copyWith(color: ColorManager.darkGrey)),
          SizedBox(height: 8.h),
          Text(subtitle, style: TextStyles.font14GreyRegular, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
