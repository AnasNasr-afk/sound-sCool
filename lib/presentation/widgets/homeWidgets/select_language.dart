import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/business_logic/homeCubit/home_cubit.dart';
import 'package:sounds_cool/business_logic/homeCubit/home_states.dart';

import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';
import 'language_item.dart';
import 'level_item.dart';

class SelectLanguage extends StatelessWidget {
  const SelectLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        var cubit = HomeCubit.get(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              // Dropdown header container
              Container(
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorManager.mainGrey.withValues(alpha: 0.3),                    width: 1.2.w,
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.darkGrey.withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Language dropdown
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Select Language",
                            style: TextStyles.font14GreyRegular,
                          ),
                          SizedBox(height: 8.h),
                          GestureDetector(
                            onTap: () => cubit.toggleSection("language"),
                            child: _buildDropdownWithFlag(
                              cubit.selectedLanguage,
                              _languageFlags[cubit.selectedLanguage]!,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),

                    // Level dropdown
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Select Level",
                            style: TextStyles.font14GreyRegular),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () => cubit.toggleSection("level"),
                          child: _buildDropdown(cubit.selectedLevel,
                              isSmall: true),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Animated expanded section
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildExpandedSection(cubit),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Map languages to their flag assets
  Map<String, String> get _languageFlags => {
    "German": "assets/images/germany.png",
    "English": "assets/images/english.png",
    "Italian": "assets/images/italy.png",
    "Spanish": "assets/images/spain.png",
    "French": "assets/images/france.png",
  };

  /// Builds the expanded content depending on cubit state
  Widget _buildExpandedSection(HomeCubit cubit) {
    switch (cubit.expandedSection) {
      case "language":
        return _buildLanguageOptions(cubit);
      case "level":
        return _buildLevelOptions(cubit);
      default:
        return const SizedBox.shrink();
    }
  }

  /// Language options row
  Widget _buildLanguageOptions(HomeCubit cubit) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            LanguageItem(
              text: "German",
              assetPath: _languageFlags["German"]!,
              isSelected: cubit.selectedLanguage == "German",
              onTap: () => cubit.selectLanguage("German"),
            ),
            SizedBox(width: 10.w),
            LanguageItem(
              text: "English",
              assetPath: _languageFlags["English"]!,
              isSelected: cubit.selectedLanguage == "English",
              onTap: () => cubit.selectLanguage("English"),
            ),
            SizedBox(width: 10.w),
            LanguageItem(
              text: "Italian",
              assetPath: _languageFlags["Italian"]!,
              isSelected: cubit.selectedLanguage == "Italian",
              onTap: () => cubit.selectLanguage("Italian"),
            ),
            SizedBox(width: 10.w),
            LanguageItem(
              text: "Spanish",
              assetPath: _languageFlags["Spanish"]!,
              isSelected: cubit.selectedLanguage == "Spanish",
              onTap: () => cubit.selectLanguage("Spanish"),
            ),
            SizedBox(width: 10.w),
            LanguageItem(
              text: "French",
              assetPath: _languageFlags["French"]!,
              isSelected: cubit.selectedLanguage == "French",
              onTap: () => cubit.selectLanguage("French"),
            ),


          ],
        ),
      ),
    );
  }

  /// Level options row
  Widget _buildLevelOptions(HomeCubit cubit) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["A1", "A2", "B1", "B2", "C1", "C2"]
            .map(
              (level) => LevelItem(
            text: level,
            isSelected: cubit.selectedLevel == level,
            onTap: () => cubit.selectLevel(level),
          ),
        )
            .toList(),
      ),
    );
  }

  /// Dropdown builder with flag
  Widget _buildDropdownWithFlag(String text, String assetPath) {
    return Container(
      width: 170.w,
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: ColorManager.mainGreen.withValues(alpha: 0.08),
        border: Border.all(
          color: ColorManager.mainGreen.withValues(alpha: 0.5),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Image.asset(assetPath, width: 22.w, height: 22.h),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyles.font20BlackBold.copyWith(
                color: ColorManager.mainGreen,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorManager.mainGreen,
            size: 24.w,
          ),
        ],
      ),
    );
  }

  /// Simple dropdown for levels
  Widget _buildDropdown(String text, {bool isSmall = false}) {
    return Container(
      width: isSmall ? 60.w : 170.w,
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 9.w),
      decoration: BoxDecoration(
        color: ColorManager.mainGreen.withValues(alpha: 0.08),
        border: Border.all(
          color: ColorManager.mainGreen.withValues(alpha: 0.5),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: isSmall
                ? TextStyles.font10BlackSemiBold
                .copyWith(fontSize: 12.sp, color: ColorManager.mainGreen)
                : TextStyles.font20BlackBold,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorManager.mainGreen,
            size: isSmall ? 18.w : 24.w,
          ),
        ],
      ),
    );
  }
}
