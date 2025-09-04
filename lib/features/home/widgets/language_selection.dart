import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../core/theming/color_manager.dart';

enum PracticeStage { generate, record, feedback }

class LanguageSelection extends StatefulWidget {
  const LanguageSelection({super.key});

  @override
  State<LanguageSelection> createState() => _LanguageSelectionState();
}

class _LanguageSelectionState extends State<LanguageSelection> {
  String selectedLanguage = 'German';
  String selectedLevel = 'A2';
  PracticeStage currentStage = PracticeStage.generate;
  String generatedText = '';
  final List<String> words = [];
  final Map<String, Color> wordColors = {};

  final Map<String, String> languageFlags = {
    'German': '🇩🇪',
    'Spanish': '🇪🇸',
    'French': '🇫🇷',
    'Italian': '🇮🇹',
  };

  final List<String> levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            'Select language',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),

        // Selection container
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: ColorManager.mainGrey.withValues(alpha: 0.9),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Language dropdown
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: selectedLanguage,
                    items: languageFlags.entries.map((entry) {
                      return DropdownMenuItem<String>(
                        value: entry.key,
                        child: Row(
                          children: [
                            Text(
                              entry.value,
                              style: TextStyle(fontSize: 16.sp , color: ColorManager.mainBlack),
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorManager.mainBlack,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedLanguage = value;
                          _resetPractice();
                        });
                      }
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 40.h,
                      padding: EdgeInsets.zero,
                      decoration: const BoxDecoration(),
                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        color: Colors.white,
                      ),
                      elevation: 4,
                      offset: Offset(0, 4.h),
                    ),
                    menuItemStyleData: MenuItemStyleData(
                      height: 35.h,

                    ),
                    customButton: Row(
                      children: [
                        Text(
                          languageFlags[selectedLanguage]!,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          selectedLanguage,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: ColorManager.mainBlack,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: ColorManager.mainBlack,
                          size: 16.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 20.w),

              // Level dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton2<String>(
                  value: selectedLevel,
                  items: levels.map((level) {
                    return DropdownMenuItem<String>(
                      value: level,
                      child: Text(
                        level,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedLevel = value;
                        _resetPractice();
                      });
                    }
                  },
                  buttonStyleData: ButtonStyleData(
                    height: 100.h,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  iconStyleData: IconStyleData(
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                  dropdownStyleData: DropdownStyleData(
                    maxHeight: 180.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: Colors.white,
                    ),
                    elevation: 4,
                    offset: Offset(-50.w, 4.h),
                  ),
                  menuItemStyleData: MenuItemStyleData(
                    height: 35.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                  ),
                  customButton: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          selectedLevel,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _resetPractice() {
    currentStage = PracticeStage.generate;
    generatedText = '';
    words.clear();
    wordColors.clear();
  }
}