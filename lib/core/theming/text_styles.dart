import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_manager.dart';

class TextStyles {
  static TextStyle font22BlackBold = GoogleFonts.ibmPlexSansJp(
    fontSize: 22.sp,
    color: ColorManager.mainBlack,
    fontWeight: FontWeight.bold,
  );
  static TextStyle font14GreyRegular = GoogleFonts.ibmPlexSansJp(
    fontSize: 14.sp,
    color: ColorManager.darkGrey,
    fontWeight: FontWeight.normal,
  );
  static TextStyle font20BlackBold = GoogleFonts.ibmPlexSansJp(
    fontSize: 20.sp,
    color: ColorManager.mainBlack,
    fontWeight: FontWeight.bold,
  );
  static TextStyle font10BlackSemiBold = GoogleFonts.ibmPlexSansJp(
    fontSize: 10.sp,
    color: ColorManager.mainBlack,
    fontWeight: FontWeight.w600,
  );
  static TextStyle font16BlackSemiBold = GoogleFonts.ibmPlexSansJp(
    fontSize: 16.sp,
    color: ColorManager.mainBlack,
    fontWeight: FontWeight.w600,
  );
  static TextStyle font12GreenMedium = GoogleFonts.ibmPlexSansJp(
    fontSize: 12.sp,
    color: ColorManager.mainGreen,
    fontWeight: FontWeight.w600,
  );
}