import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';


class AuthIntroWidget extends StatelessWidget {
  const AuthIntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/animations/robot.json',
      width: 200.w,
      height: 200.h,
      fit: BoxFit.contain,
    );
  }
}
