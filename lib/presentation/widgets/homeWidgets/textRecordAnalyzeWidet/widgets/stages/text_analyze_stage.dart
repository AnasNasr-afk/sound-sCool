import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/text_styles.dart';
import '../components/action_button.dart';
import '../components/analyzing_animation.dart';

class TextAnalyzeStage extends StatelessWidget {
  const TextAnalyzeStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);
        if (cubit.isAnalyzing) {
          return const AnalyzingAnimation();
        }
        String originalText = cubit.displayedText ?? "";
        String recordedText = cubit.finalRecordedText ?? "";

        final analysis = _analyzeTexts(originalText, recordedText);

        return Column(
          children: [
            // Score Header
            _buildScoreHeader(analysis),
            SizedBox(height: 16.h),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Only show mistakes if there are any
                    if (analysis.missedWords > 0)
                      _buildMissedWordsCard(analysis)
                    else
                      _buildPerfectScoreCard(),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.h),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ActionButton(
                    label: "Try Again",
                    icon: Icons.refresh,
                    backgroundColor: ColorManager.mainGreen,
                    onPressed: () {
                      cubit.goToStage(Stage.record);
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ActionButton(
                    label: "New Text",
                    icon: Icons.add,
                    backgroundColor: ColorManager.darkGrey,
                    onPressed: () {
                      cubit.goToStage(Stage.generate);
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildScoreHeader(TextAnalysis analysis) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: _getAccuracyColor(analysis.accuracy).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getAccuracyColor(analysis.accuracy).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Accuracy',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: ColorManager.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${analysis.accuracy.toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.bold,
                  color: _getAccuracyColor(analysis.accuracy),
                  height: 1,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                _getAccuracyLabel(analysis.accuracy),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: ColorManager.darkGrey.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildMiniStat(
                icon: Icons.check_circle_outline,
                value: analysis.correctWords,
                label: 'Correct',
                color: ColorManager.mainGreen,
              ),
              SizedBox(height: 8.h),
              _buildMiniStat(
                icon: Icons.error_outline,
                value: analysis.missedWords,
                label: 'Missed',
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat({
    required IconData icon,
    required int value,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16.w, color: color),
        SizedBox(width: 4.w),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: ColorManager.darkGrey,
          ),
        ),
      ],
    );
  }

  Widget _buildPerfectScoreCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: ColorManager.mainGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.mainGreen.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: ColorManager.mainGreen.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.celebration_outlined,
              size: 48.w,
              color: ColorManager.mainGreen,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Perfect Score!',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: ColorManager.mainGreen,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'You pronounced all words correctly',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: ColorManager.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissedWordsCard(TextAnalysis analysis) {
    List<String> missedWordsList = [];
    for (int i = 0; i < analysis.originalWords.length; i++) {
      if (!analysis.matchedIndices.contains(i)) {
        missedWordsList.add(analysis.originalWords[i]);
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorManager.darkGrey.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.priority_high,
                  color: Colors.red.shade700,
                  size: 20.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Words to Practice',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorManager.mainBlack,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'These words were not detected in your recording',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: ColorManager.darkGrey.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: missedWordsList.map((word) {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  word,
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  TextAnalysis _analyzeTexts(String original, String recorded) {
    List<String> originalWords = _cleanAndSplit(original);
    List<String> recordedWords = _cleanAndSplit(recorded);

    List<String> originalLower = originalWords.map((w) => w.toLowerCase()).toList();
    List<String> recordedLower = recordedWords.map((w) => w.toLowerCase()).toList();

    Set<int> matchedIndices = {};
    int correctWords = 0;

    for (int i = 0; i < originalLower.length; i++) {
      if (recordedLower.contains(originalLower[i])) {
        matchedIndices.add(i);
        correctWords++;
      }
    }

    double accuracy = originalWords.isEmpty
        ? 0.0
        : (correctWords / originalWords.length) * 100;

    return TextAnalysis(
      originalWords: originalWords,
      recordedWords: recordedWords,
      matchedIndices: matchedIndices,
      correctWords: correctWords,
      missedWords: originalWords.length - correctWords,
      accuracy: accuracy,
    );
  }

  List<String> _cleanAndSplit(String text) {
    if (text.isEmpty) return [];
    return text
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .toList();
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 80) return ColorManager.mainGreen;
    if (accuracy >= 60) return Colors.orange;
    return Colors.red;
  }

  String _getAccuracyLabel(double accuracy) {
    if (accuracy >= 90) return 'Excellent';
    if (accuracy >= 80) return 'Great job';
    if (accuracy >= 60) return 'Good effort';
    if (accuracy >= 40) return 'Keep practicing';
    return 'Try again';
  }
}

class TextAnalysis {
  final List<String> originalWords;
  final List<String> recordedWords;
  final Set<int> matchedIndices;
  final int correctWords;
  final int missedWords;
  final double accuracy;

  TextAnalysis({
    required this.originalWords,
    required this.recordedWords,
    required this.matchedIndices,
    required this.correctWords,
    required this.missedWords,
    required this.accuracy,
  });
}