import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/presentation/widgets/recentSession/recording_view.dart';
import 'package:sounds_cool/presentation/widgets/recentSession/text_generating_error.dart';

import '../../../business_logic/homeCubit/home_cubit.dart';
import '../../../business_logic/homeCubit/home_states.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';
import '../highlighted_text.dart';
import '../loading_animations.dart';


class SessionBodyContent extends StatelessWidget {
  const SessionBodyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        // Text generation loading
        if (state is GenerateTextLoadingState) {
          return buildLoadingAnimation();
        }

        // Text generation success - show plain text
        else if (state is GenerateTextSuccessState) {
          return buildGeneratedTextView(state.generatedText);
        }

        // Text generation error
        else if (state is GenerateTextErrorState) {
          return TextGenerationErrorView(error: state.error);
        }

        // Recording in progress - show text with current word highlighting
        else if (state is SpeechListeningState) {
          return buildRecordingView(cubit, null);
        }

        // Recording with partial results - highlight current word in orange
        else if (state is SpeechPartialResultState) {
          return buildRecordingView(cubit, state.partialText);
        }

        // Recording timer tick - maintain highlighting
        else if (state is SpeechTimerTickState) {
          return buildRecordingView(cubit, cubit.currentWord, timeDisplay: state.formattedTime);
        }

        // Recording completed
        else if (state is SpeechStoppedState) {
          return RecordingCompleteView(cubit: cubit);
        }

        // Recording cancelled
        else if (state is SpeechCancelledState) {
          return RecordingCancelledView(cubit: cubit);
        }

        // Speech/Recording error
        else if (state is SpeechErrorState) {
          return RecordingErrorView(error: state.error);
        }

        // Pronunciation analysis loading
        else if (state is PronunciationAnalysisLoadingState) {
          return const AnalysisLoadingView();
        }

        // Pronunciation results - show green/red highlighting
        else if (state is PronunciationResultState) {
          return buildResultsView(cubit, state);
        }

        // Default state
        else {
          return buildDefaultView(cubit);
        }
      },
    );
  }

  Widget buildGeneratedTextView(String text) {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SimpleHighlightedText(text: text),
        ),
      ),
    );
  }

  Widget buildRecordingView(HomeCubit cubit, String? currentWord, {String? timeDisplay}) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show text with current word highlighted
          if (cubit.displayedText != null) ...[
            Padding(
              padding: EdgeInsets.all(16.w),
              child: SimpleHighlightedText(
                text: cubit.displayedText!,
                currentWord: currentWord,
              ),
            ),
            SizedBox(height: 30.h),
          ],

          // Recording indicator
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Red recording dot
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  timeDisplay ?? '0:00 / 0:30',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  'FREE',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultsView(HomeCubit cubit, PronunciationResultState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Accuracy score
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: ColorManager.mainGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: ColorManager.mainGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics_outlined, color: ColorManager.mainGreen, size: 20.sp),
                SizedBox(width: 8.w),
                Text(
                  'Accuracy: ${(state.accuracy * 100).toStringAsFixed(0)}%',
                  style: TextStyles.font14GreyRegular.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.mainGreen,
                  ),
                ),
              ],
            ),
          ),

          // Text with results highlighting
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SimpleHighlightedText(
              text: cubit.displayedText!,
              wordResults: state.wordAnalysis,
            ),
          ),

          SizedBox(height: 20.h),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () => cubit.retryPronunciation(),
                icon: Icon(Icons.refresh, size: 16.sp),
                label: const Text('Try Again'),
                style: TextButton.styleFrom(foregroundColor: ColorManager.mainGreen),
              ),
              TextButton.icon(
                onPressed: () => cubit.startNewSession(),
                icon: Icon(Icons.add, size: 16.sp),
                label: const Text('New Text'),
                style: TextButton.styleFrom(foregroundColor: ColorManager.mainGreen),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDefaultView(HomeCubit cubit) {
    return Center(
      child: Text(
        cubit.displayedText ?? "Start your new session",
        style: TextStyles.font14GreyRegular,
        textAlign: TextAlign.center,
      ),
    );
  }
}