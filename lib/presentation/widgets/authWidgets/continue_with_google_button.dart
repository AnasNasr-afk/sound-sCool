import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sounds_cool/business_logic/authCubit/auth_cubit.dart';
import 'package:sounds_cool/business_logic/authCubit/auth_states.dart';

import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const ContinueWithGoogleButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      builder: (context, state) {
        bool isLoading = state is GoogleSignInLoadingState;

        return Container(
          width: double.infinity,
          height: 52.h, // Match login button
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r), // Match other elements
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
            color: Colors.grey[50], // Match background
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06), // Softer shadow
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: TextButton(
            onPressed: isLoading
                ? null
                : () => AuthCubit.get(context).signInWithGoogle(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r), // Match container
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
            ),
            child: isLoading
                ?  CupertinoActivityIndicator(color: ColorManager.mainBlack)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.grey[800],
                        size: 18.w,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Continue with Google",
                        style: TextStyles.font16LightBlackSemiBold,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
