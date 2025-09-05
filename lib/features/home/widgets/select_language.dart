import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theming/color_manager.dart';
import '../../../core/theming/text_styles.dart';
import '../../../core/widgets/language_item.dart';
import '../../../core/widgets/level_item.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String selectedLanguage = "German";
  String selectedLevel = "A2";

  /// Track which section is expanded: "language", "level", or null
  String? expandedSection;

  // Map languages to their flag assets
  final Map<String, String> languageFlags = {
    "German": "assets/images/germany.png",
    "English": "assets/images/English.png",
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Dropdown header container
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: ColorManager.darkGrey.withValues(alpha: 0.3),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: const Offset(1, 3),
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
                        onTap: () => _toggleSection("language"),
                        child: _buildDropdownWithFlag(
                          selectedLanguage,
                          languageFlags[selectedLanguage]!,
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
                    Text("Select Level", style: TextStyles.font14GreyRegular),
                    SizedBox(height: 8.h),
                    GestureDetector(
                      onTap: () => _toggleSection("level"),
                      child: _buildDropdown(selectedLevel, isSmall: true),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Animated expanded section
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildExpandedSection(),
          ),
        ],
      ),
    );
  }

  /// Builds the expanded content depending on state
  Widget _buildExpandedSection() {
    switch (expandedSection) {
      case "language":
        return _buildLanguageOptions();
      case "level":
        return _buildLevelOptions();
      default:
        return const SizedBox.shrink();
    }
  }

  /// Language options row
  Widget _buildLanguageOptions() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        children: [
          LanguageItem(
            text: "German",
            assetPath: languageFlags["German"]!,
            isSelected: selectedLanguage == "German",
            onTap: () => _selectLanguage("German"),
          ),
          SizedBox(width: 10.w),
          LanguageItem(
            text: "English",
            assetPath: languageFlags["English"]!,
            isSelected: selectedLanguage == "English",
            onTap: () => _selectLanguage("English"),
          ),
        ],
      ),
    );
  }

  /// Level options row
  Widget _buildLevelOptions() {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: ["A1", "A2", "B1", "B2", "C1", "C2"]
            .map(
              (level) => LevelItem(
                text: level,
                isSelected: selectedLevel == level,
                onTap: () => _selectLevel(level),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: isSmall
                ? TextStyles.font10BlackSemiBold.copyWith(fontSize: 12.sp , color: ColorManager.mainGreen)
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

  // Todo: Move to cubit
  void _toggleSection(String section) {
    setState(() {
      expandedSection = expandedSection == section ? null : section;
    });
  }

  // Todo: Move to cubit

  void _selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
      expandedSection = null;
    });
  }

  // Todo: Move to cubit

  void _selectLevel(String level) {
    setState(() {
      selectedLevel = level;
      expandedSection = null;
    });
  }
}
