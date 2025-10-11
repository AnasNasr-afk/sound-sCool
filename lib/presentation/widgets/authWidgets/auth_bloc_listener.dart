import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../../../business_logic/authCubit/auth_states.dart';
import '../../../routing/routes.dart';

class AuthBlocListener extends StatelessWidget {
  const AuthBlocListener({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Oops! Your email or password seems incorrect. Please try again.",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(16.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12.r)),
              ),
            ),
          );
        } else if (state is SignupSuccessState) {
          Navigator.pushReplacementNamed(context, Routes.homeScreen);
        } else if (state is SignupErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Oops! ${state.error}. Please try again.",
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
                ),
                backgroundColor: Colors.redAccent,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(16.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.r)),
                ),
              )

          );
        }
      },
      child: const SizedBox(),
    );
  }
}
