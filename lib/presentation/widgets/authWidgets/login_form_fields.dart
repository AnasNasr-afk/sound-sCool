import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../business_logic/authCubit/auth_cubit.dart';
import '../app_text_field.dart';

class LoginFormFields extends StatefulWidget {
  const LoginFormFields({super.key});

  @override
  State<LoginFormFields> createState() => _LoginFormFieldsState();
}

class _LoginFormFieldsState extends State<LoginFormFields> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    var cubit = AuthCubit.get(context);
    return Form(
      key: cubit.loginFormKey,
      child: Column(
        children: [
          AppTextFormField(
            controller: cubit.loginEmailController,
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
            },
          ),
          SizedBox(height: 16.h),

          AppTextFormField(
            controller: cubit.loginPasswordController,
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
