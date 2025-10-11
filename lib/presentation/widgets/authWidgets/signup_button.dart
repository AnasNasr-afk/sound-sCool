import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../business_logic/authCubit/auth_cubit.dart';
import '../../../business_logic/authCubit/auth_states.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class SignupButton extends StatelessWidget {
  const SignupButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        var cubit = AuthCubit.get(context);
        bool isLoading = state is SignupLoadingState;

        return Container(
          width: double.infinity.w,
          height: 50.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                ColorManager.gradientLightDark,
                ColorManager.mainGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: TextButton(
            onPressed: isLoading ? null : () => cubit.signupUser(),
            style: const ButtonStyle(
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
            ),
            child: isLoading
                ? const CupertinoActivityIndicator(color: Colors.white)
                : Text(
              "Sign Up",
              style: TextStyles.font14GreyRegular.copyWith(
                color: ColorManager.whiter,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        );
      },
    );
  }
}
