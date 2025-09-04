import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theming/color_manager.dart';

class TextGeneratorWidget extends StatefulWidget {
  const TextGeneratorWidget({super.key});

  @override
  State<TextGeneratorWidget> createState() => _TextGeneratorWidgetState();
}

class _TextGeneratorWidgetState extends State<TextGeneratorWidget> {
  String? generatedText;

  void _generateText() {
    setState(() {
      generatedText =
          "Once upon a time in a quiet village, there lived a curious mind who always sought knowledge. "
          "Every page read was a step into a new world, and every word carried a spark of discovery...dfklbdbmdfkbldfbdfbkl;bmgkblfmbgflkbmfgblfkgbmfgklbmfbklfgbmfklbmfgblfmblfkgbmfglkbfgmblkfgbmfgblkfgmblkfgbmflkbmfgblkfgmblkfgmbflbmfgklbmfgbkgb";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Text container
        Expanded(
          child: generatedText == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      size: 48.w,
                      color: ColorManager.darkGrey,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'No recent sessions yet',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorManager.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: ColorManager.mainGrey, // warm brown border
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.brown.withValues(alpha: 0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.6),
                        blurRadius: 6,
                        spreadRadius: -2,
                        offset: const Offset(-2, -2),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      generatedText ?? "Once upon a time...",
                      style: GoogleFonts.merriweather(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF3E2723), // deep brown ink
                        height: 1.7,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ),
        ),

        /// Floating button
        Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: GestureDetector(
            onTap: _generateText,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: ColorManager.primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.generating_tokens_rounded,
                color: Colors.white,
                size: 28.w,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
