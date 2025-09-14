import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class AuthButtons extends StatelessWidget {
  final bool isLogin;

  const AuthButtons({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (isLogin) {
          // TODO: handle login
        } else {
          // TODO: handle signup
        }
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ColorManager.mainGreen),
        foregroundColor: WidgetStatePropertyAll(ColorManager.whiter),
        minimumSize: WidgetStatePropertyAll(
          Size(double.infinity.w, 50.h),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
      child: Text(
        isLogin ? "Login" : "Sign Up",
        style: TextStyles.font14GreyRegular.copyWith(
          color: ColorManager.whiter,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3
        ),
      ),
    );
  }
}
