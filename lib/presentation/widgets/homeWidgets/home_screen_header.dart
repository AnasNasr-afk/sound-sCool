import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';


class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('Hi Anas', style: TextStyles.font22BlackBold),
          SizedBox(width: 10.w),
          Image.asset(
            'assets/images/saluteIcon.png',
            fit: BoxFit.cover,
            width: 24.w,
            height: 24.h,
            color: ColorManager.darkGrey,
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.darkGrey.withValues(alpha: 0.3),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Image.asset(
                'assets/images/settingsIcon.png',
                fit: BoxFit.cover,
                width: 24.w,
                height: 24.h,
                color: ColorManager.mainBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
