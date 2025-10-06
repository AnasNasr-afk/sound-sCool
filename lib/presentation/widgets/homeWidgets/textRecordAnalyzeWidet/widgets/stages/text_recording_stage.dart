import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../helpers/text_styles.dart';
import '../components/action_button.dart';
import '../components/magic_overlay_animation.dart';
import '../components/text_card.dart';
import '../../../../../../helpers/color_manager.dart';

class TextRecordingStage extends StatelessWidget {
  const TextRecordingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is RecordSuccessState) {
          final cubit = HomeCubit.get(context);

          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return MagicOverlayAnimation(
                onComplete: () {
                  Navigator.of(context).pop();
                  cubit.goToStage(Stage.analyze);
                },
              );
            },
          );
        }

        if (state is RecordErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        String displayText = "";

        if (cubit.finalRecordedText != null && cubit.finalRecordedText!.isNotEmpty) {
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

        return Column(
          children: [
            // First container: generated text for reading
            TextCard(
              text: cubit.displayedText?.isEmpty ?? true
                  ? "No practice text generated yet."
                  : cubit.displayedText!,
            ),
            SizedBox(height: 12.h),

            // Second container: recording text / progress
            Expanded(child: TextCard(text: displayText)),
            SizedBox(height: 12.h),

            // Timer UI (only when recording)
            if (cubit.isRecording) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.mainBlack,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Text(
                          cubit.timerDisplay,
                          style: TextStyles.font12GreenMedium.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
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
              SizedBox(height: 12.h),
            ],

            // Action button with dynamic color
            if (!cubit.isRecording)
              ActionButton(
                label: "Start Recording",
                icon: Icons.mic,
                backgroundColor: ColorManager.mainGreen,
                onPressed: () {
                  cubit.startRecording();
                },
              ),

          ],
        );
      },
    );
  }

  // Audio Visualization Widget
  Widget _buildAudioVisualization(double soundLevel) {
    // Normalize sound level (typically ranges from -2 to 10)
    double normalizedLevel = (soundLevel + 2) / 12;
    normalizedLevel = normalizedLevel.clamp(0.0, 1.0);

    return Container(
      height: 50.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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