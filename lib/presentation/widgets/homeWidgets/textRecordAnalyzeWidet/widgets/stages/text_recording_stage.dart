import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../helpers/components.dart';
import '../../../../../../helpers/text_styles.dart';
import '../components/action_button.dart';
import '../components/analyze_loading.dart';
import '../components/text_card.dart';
import '../../../../../../helpers/color_manager.dart';

class TextRecordingStage extends StatelessWidget {
  const TextRecordingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        // if (state is RecordSuccessState) {
        //
        //   final cubit = HomeCubit.get(context);
        //   cubit.goToStage(Stage.analyze);
        //   showDialog(
        //     context: context,
        //     barrierDismissible: false,
        //     barrierColor: Colors.transparent,
        //     builder: (BuildContext context) {
        //       return MagicOverlayAnimation(
        //         onComplete: () {
        //           Navigator.of(context).pop();
        //           cubit.goToStage(Stage.analyze);
        //         },
        //       );
        //     },
        //   );
        // }

        if (state is RecordSuccessState) {
          final cubit = HomeCubit.get(context);

          showDialog(
            context: context,
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: false,
            builder: (context) {
              return AnalyzeLoading(
                onComplete: () {
                  cubit.goToStage(Stage.analyze);
                },
              );
            },
          );
        }

        if (state is RecordErrorState) {

        }
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        String displayText = "";

        if (cubit.finalRecordedText != null &&
            cubit.finalRecordedText!.isNotEmpty) {
          displayText = cubit.finalRecordedText!;
        } else if (cubit.isRecording) {
          if (cubit.currentRecognizedWords.isNotEmpty) {
            displayText = cubit.currentRecognizedWords;
          } else {
            displayText = "Speak now...";
          }
        } else {
          displayText = "Tap button to start recording";
        }

        // FULL SCREEN MODE WHEN RECORDING
        if (cubit.isRecording) {
          return Column(
            children: [
              // Minimized reference text (top) - collapsible
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: ColorManager.mainGrey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: ColorManager.mainGrey.withValues(alpha: 0.3),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    cubit.displayedText?.isEmpty ?? true
                        ? "No text"
                        : cubit.displayedText!,
                    style: TextStyles.font12GreenMedium.copyWith(
                      color: ColorManager.mainBlack,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // MAIN RECORDING DISPLAY - FULL SCREEN
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Card background + scrollable text
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorManager.mainGreen.withValues(alpha: 0.4),
                              width: 2.w,
                            ),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Padding(
                            // Keep inner padding so positioned button does not cover text
                            padding: EdgeInsets.fromLTRB(16.w, 16.h + 6.h, 16.w, 16.h),
                            child: SingleChildScrollView(
                              child: Text(
                                displayText,
                                style:
                                TextStyles.font16BlackSemiBold.copyWith(
                                  fontSize: 14.sp,
                                  color: ColorManager.mainBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Cancel button placed in card header area (top-right)
                      // AnimatedOpacity gives subtle entrance/exit when recording state toggles.
                      Positioned(
                        top: -12.h,
                        right: -12.w,
                        child: AnimatedOpacity(
                          opacity: cubit.isRecording ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOut,
                          child: Semantics(
                            button: true,
                            label: 'Discard recording',
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => cubit.resetRecordingState(),
                                borderRadius: BorderRadius.circular(24.r),
                                child: Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: ColorManager.mainGrey,
                                    border: Border.all(
                                      color: ColorManager.mainGreen,
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorManager.mainBlack.withValues(alpha: 0.03),
                                        blurRadius: 6.r,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.close_rounded,
                                    size: 20.sp,
                                    color: ColorManager.mainBlack,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Timer & Stop Button - Bottom Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.mainBlack,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          cubit.timerDisplay,
                          style: TextStyles.font12GreenMedium.copyWith(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 65.w,
                    height: 65.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.isRecordingColor,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.isRecordingColor.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12.r,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      onPressed: () {
                        cubit.stopRecording();
                      },
                      icon: Icon(Icons.stop, size: 32.w, color: Colors.white),
                      splashRadius: 30.r,
                    ),
                  ),

                  _buildAudioVisualization(cubit.currentSoundLevel),
                ],
              ),
            ],
          );
        }

        // NORMAL MODE WHEN NOT RECORDING
        return Column(
          children: [
            // Show generated text ONLY if available; otherwise don't render the card
            if (cubit.displayedText != null && cubit.displayedText!.isNotEmpty) ...[
              Expanded(
                child: TextCard(
                  text: cubit.displayedText!,
                ),
              ),
              SizedBox(height: 12.h),
            ],

            // Action button with dynamic color
            ActionButton(
              label: "Start Recording",
              icon: Icons.mic,
              onPressed: () async {
                if (!cubit.isRecording) {
                  bool canRecord = await cubit.canRecordToday();

                  if (!canRecord) {
                    DailyLimitDialog.show(context);
                    return;
                  }
                  cubit.startRecording();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Audio Visualization Widget
  Widget _buildAudioVisualization(double soundLevel) {
    double normalizedLevel = (soundLevel + 2) / 12;
    normalizedLevel = normalizedLevel.clamp(0.0, 1.0);

    return SizedBox(
      height: 40.h,
      child: Row(
        children: List.generate(7, (index) {
          // Create wave effect - bars in middle are taller
          double barMultiplier = 1.0;
          if (index == 3) {
            barMultiplier = 1.0;
          } else if (index == 2 || index == 4) {
            barMultiplier = 0.8;
          } else if (index == 1 || index == 5) {
            barMultiplier = 0.6;
          } else {
            barMultiplier = 0.4;
          }

          double barHeight = 8.h + (normalizedLevel * 30.h * barMultiplier);

          return AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            width: 4.w,
            height: barHeight,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              color: normalizedLevel > 0.1
                  ? ColorManager.mainGreen
                  : ColorManager.mainGrey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          );
        }),
      ),
    );
  }
}


