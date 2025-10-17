import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title
        Padding(
          padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
          child: Text(
            title.toUpperCase(),
            style: TextStyles.font16LightBlackSemiBold.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
        ),

        // Group container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: ColorManager.mainGrey.withValues(alpha: 0.3),
              width: 1.2.w,
            ),
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.darkGrey.withValues(alpha: 0.1),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              final isLast = index == children.length - 1;
              return Column(
                children: [
                  children[index],
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 50.w, // align with text
                      color: Colors.grey.shade300,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
