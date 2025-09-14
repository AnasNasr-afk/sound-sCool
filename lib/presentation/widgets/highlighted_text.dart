import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';

class SimpleHighlightedText extends StatelessWidget {
  final String text;
  final String? currentWord; // Word currently being spoken (orange)
  final List<bool>? wordResults; // Final results (green/red)

  const SimpleHighlightedText({
    super.key,
    required this.text,
    this.currentWord,
    this.wordResults,
  });

  @override
  Widget build(BuildContext context) {
    // Split text into words, keeping spaces
    List<String> parts = [];
    List<String> words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      parts.add(words[i]);
      if (i < words.length - 1) {
        parts.add(' '); // Add space between words
      }
    }

    return Wrap(
      children: parts.map((part) {
        // Skip spaces
        if (part == ' ') {
          return Text(' ', style: TextStyles.font14GreyRegular.copyWith(fontSize: 15.sp));
        }

        // Clean word for comparison (remove punctuation)
        String cleanWord = part.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');

        // Find word index for results
        int wordIndex = -1;
        List<String> textWords = text.toLowerCase()
            .replaceAll(RegExp(r'[^\w\s]'), '')
            .split(' ')
            .where((w) => w.isNotEmpty)
            .toList();

        for (int i = 0; i < textWords.length; i++) {
          if (textWords[i] == cleanWord) {
            wordIndex = i;
            break;
          }
        }

        Color backgroundColor = Colors.transparent;
        Color textColor = ColorManager.darkGrey;
        FontWeight fontWeight = FontWeight.normal;

        // Show final results (green/red) - highest priority
        if (wordResults != null && wordIndex >= 0 && wordIndex < wordResults!.length) {
          if (wordResults![wordIndex]) {
            backgroundColor = ColorManager.mainGreen.withValues(alpha: 0.8);
            textColor = Colors.white;
            fontWeight = FontWeight.w600;
          } else {
            backgroundColor = Colors.red.withValues(alpha: 0.8);
            textColor = Colors.white;
            fontWeight = FontWeight.w600;
          }
        }
        // Show current word (orange) - only when no final results
        else if (currentWord != null && wordResults == null) {
          String currentClean = currentWord!.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
          if (cleanWord == currentClean && cleanWord.isNotEmpty) {
            backgroundColor = Colors.orange.withValues(alpha: 0.8);
            textColor = Colors.white;
            fontWeight = FontWeight.w600;
          }
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 1.w),
          padding: backgroundColor != Colors.transparent
              ? EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h)
              : EdgeInsets.zero,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            part,
            style: TextStyles.font14GreyRegular.copyWith(
              fontSize: 15.sp,
              color: textColor,
              fontWeight: fontWeight,
              height: 1.6,
            ),
          ),
        );
      }).toList(),
    );
  }
}