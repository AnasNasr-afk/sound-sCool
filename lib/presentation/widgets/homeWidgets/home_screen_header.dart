import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/presentation/screens/settings_screen.dart';

import '../../../business_logic/settingsCubit/settings_cubit.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';
import '../../../routing/routes.dart';
import '../../screens/edit_screen.dart';


class HomeScreenHeader extends StatelessWidget {
  const HomeScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            FirebaseAuth.instance.currentUser?.displayName != null
                ? 'Hi, ${FirebaseAuth.instance.currentUser?.displayName!.split(' ').first}'
                : 'Hi, User',
          style: TextStyles.font22BlackBold),
          SizedBox(width: 10.w),
          Image.asset(
            'assets/images/saluteIcon.png',
            fit: BoxFit.cover,
            width: 24.w,
            height: 24.h,
            color: ColorManager.darkGrey,
          ),
          Spacer(),
          // add iconbutton instead


          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, Routes.settingsScreen);
            },


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
