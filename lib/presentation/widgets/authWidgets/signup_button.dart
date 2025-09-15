import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);

    return TextButton(
      onPressed: () {
        debugPrint("Signup button pressed");
        cubit.signupUser();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ColorManager.mainGreen),
        foregroundColor: WidgetStatePropertyAll(ColorManager.whiter),
        minimumSize: WidgetStatePropertyAll(Size(double.infinity.w, 50.h)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
      ),
      child: Text(
        "Sign Up",
        style: TextStyles.font14GreyRegular.copyWith(
          color: ColorManager.whiter,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}