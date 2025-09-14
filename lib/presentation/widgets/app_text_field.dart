import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String labelText;
  final bool? isObscureText;
  final Color? backgroundColor;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Function(String?) validator;

  const AppTextFormField({
    super.key,
    this.prefixIcon,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    this.suffixIcon,
    this.hintText,
    this.isObscureText,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.inputType,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType ?? TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hoverColor: ColorManager.mainBlack,
        labelText: labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: TextStyles.font14GreyRegular.copyWith(
          color: Colors.grey[700], // Better label color
        ),
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 12.h, // Reduced from 15.h to 12.h for smaller height
            ),
        focusedBorder:
            focusedBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: ColorManager.mainGreen,
                width: 1.5, // Slightly thicker for focus
              ),
              borderRadius: BorderRadius.circular(
                12.r,
              ), // Slightly smaller radius
            ),
        enabledBorder:
            enabledBorder ??
            OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[300]!, // Softer border when not focused
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          borderRadius: BorderRadius.circular(12.r),
        ),
        hintStyle:
            hintStyle ??
            TextStyles.font16BlackSemiBold.copyWith(
              color: Colors.grey[500], // Better hint color
              fontWeight: FontWeight.normal,
            ),
        hintText: hintText,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor:
            backgroundColor ??
            Colors.grey[50], // Match screen background for seamless look
      ),
      obscureText: isObscureText ?? false,
      style:
          inputTextStyle ??
          TextStyles.font16BlackSemiBold.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.normal,
            color: Colors.grey[900], // Better text color
          ),
      validator: (value) {
        return validator(value);
      },
    );
  }
}
