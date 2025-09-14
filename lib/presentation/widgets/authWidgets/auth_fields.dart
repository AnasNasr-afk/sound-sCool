import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/presentation/widgets/app_text_field.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class AuthFields extends StatelessWidget {
  final bool isLogin;
  const AuthFields({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Only show these if Sign Up
        if (!isLogin) ...[
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  prefixIcon: Icon(
                    Icons.person_outline ,
                    color: Colors.grey[700],
                    size: 25,
                  ),
                  labelText: 'First Name',
                  validator: (String? value) {},
                ),
              ),
              SizedBox(width: 16.w), // spacing between fields
              Expanded(
                child: AppTextFormField(
                  prefixIcon: Icon(
                    Icons.person_outline ,
                    color: Colors.grey[700],
                    size: 25,
                  ),
                  labelText: 'Last Name',
                  validator: (String? value) {},
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],


        // Email
        AppTextFormField(
          prefixIcon: Icon(
            Icons.email_outlined ,
            color: Colors.grey[700],
            size: 25,
          ),
          labelText: 'Email Address',
          validator: (String? p1) {  },
        ),
        SizedBox(height: 16.h),

        // Password
        AppTextFormField(
          prefixIcon: Icon(
            Icons.lock_outline ,
            color: Colors.grey[700],
            size: 25,
          ),
          isObscureText: true,
          suffixIcon: Icon(
            Icons.visibility_off,
            size: 20,
            color: Colors.grey[700],
          ),
          labelText: 'Password', validator: (String? p1) {  },
        ),
        SizedBox(height: 12.h),

        // Only show Forgot Password in Login
        if (isLogin)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Forgot Password?',
              style: TextStyles.font14GreyRegular.copyWith(
                decoration: TextDecoration.underline,
                color: ColorManager.mainBlack,
                fontSize: 12.sp,
              ),
            ),
          ),
      ],
    );
  }
}
