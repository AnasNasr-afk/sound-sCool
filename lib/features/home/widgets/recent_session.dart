import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/core/theming/text_styles.dart';
import '../../../core/theming/color_manager.dart';

class RecentSession extends StatefulWidget {
  const RecentSession({super.key});

  @override
  State<RecentSession> createState() => _RecentSessionState();
}

class _RecentSessionState extends State<RecentSession> {
  bool isEditing = false;
  String? displayedText;
  final TextEditingController _controller = TextEditingController();

  final sampleTexts = const [
    "Hello! My name is Anna and I live in Berlin. I work as a teacher and I love reading books. Every morning, I drink coffee and read the news. On weekends, I like to visit museums with my friends.",
    "The weather today is beautiful and sunny. I decided to take a walk in the park near my house. There were many people enjoying the nice day. Children were playing while their parents sat on benches.",
    "Learning a new language can be challenging but very rewarding. Practice makes perfect, so it's important to speak every day. Don't be afraid to make mistakes - they help you learn and improve.",
  ];

  void _toggleEditMode() {
    setState(() {
      isEditing = true;
      displayedText = null; // clear when editing
      _controller.clear();
    });
  }



  void _generateSampleText() {
    setState(() {
      final random = Random();
      displayedText = sampleTexts[random.nextInt(sampleTexts.length)];
      isEditing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.r),
              topRight: Radius.circular(12.r),
              bottomLeft: Radius.circular(12.r),
              bottomRight: Radius.circular(12.r),
            ),
            boxShadow: [
              BoxShadow(
                color: ColorManager.darkGrey.withValues(alpha: 0.15),
                blurRadius: 3,
                spreadRadius: 1,
                offset: const Offset(1, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Text(
                    'Recent Sessions',
                    style: TextStyles.font16BlackSemiBold,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _toggleEditMode,
                    style: TextButton.styleFrom(
                      backgroundColor:
                      ColorManager.mainGreen.withValues(alpha: 0.08),
                      foregroundColor: ColorManager.mainGreen,
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 6.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                        side: BorderSide(
                          color: ColorManager.mainGreen.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add your text',
                          style: TextStyles.font12GreenMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(Icons.add_circle_rounded,
                            size: 16.sp, color: ColorManager.mainGreen),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              // Body
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: ColorManager.mainGrey.withValues(alpha: 0.6),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.darkGrey.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: isEditing
                      ? TextFormField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    style: TextStyles.font14GreyRegular.copyWith(
                      color: ColorManager.mainBlack,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write here...",
                    ),
                  )
                      : Center(
                    child: Text(
                      displayedText ?? "Start your new session",
                      style: TextStyles.font14GreyRegular,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Action button
              Center(
                child: Container(
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        ColorManager.mainGreen,
                        ColorManager.mainGreen.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ColorManager.mainGreen.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _generateSampleText,
                    icon: Icon(
                      Icons.generating_tokens_rounded,
                      size: 28.w,
                      color: Colors.white,
                    ),
                    splashRadius: 36.r,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
