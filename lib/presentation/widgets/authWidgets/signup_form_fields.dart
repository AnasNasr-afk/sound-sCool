import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../app_text_field.dart';

class SignupFormFields extends StatefulWidget {
  const SignupFormFields({super.key});

  @override
  State<SignupFormFields> createState() => _SignupFormFieldsState();
}

class _SignupFormFieldsState extends State<SignupFormFields> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return Form(
      key: cubit.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  controller: cubit.signupFirstNameController,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.grey[700],
                    size: 25,
                  ),
                  labelText: 'First Name',
                  validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "First name is required";
                      }
                      return null; // valid
                  },
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextFormField(
                  controller: cubit.signupLastNameController,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.grey[700],
                    size: 25,
                  ),
                  labelText: 'Last Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Last name is required";
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          AppTextFormField(
            controller: cubit.signupEmailController,
            prefixIcon: Icon(
              Icons.email_outlined,
              color: Colors.grey[700],
              size: 25,
            ),
            labelText: 'Email Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Email is required";
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return "Enter a valid email";
              }
              return null;
            },

          ),
          SizedBox(height: 16.h),

          AppTextFormField(
            controller: cubit.signupPasswordController,
            prefixIcon: Icon(
              Icons.lock_outline,
              color: Colors.grey[700],
              size: 25,
            ),
            isObscureText: _isObscure,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              child: Icon(
                _isObscure ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: Colors.grey[700],
              ),
            ),
            labelText: 'Password',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Password is required";
              }

              final regex = RegExp(
                r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
              );

              if (!regex.hasMatch(value)) {
                return "Must be 8+ chars, include uppercase, number & symbol";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
