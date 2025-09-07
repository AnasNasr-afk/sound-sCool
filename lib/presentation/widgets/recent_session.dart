import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/business_logic/homeCubit/home_cubit.dart';
import 'package:sounds_cool/business_logic/homeCubit/home_states.dart';
import 'package:sounds_cool/data/models/generate_text_request.dart';
import 'package:sounds_cool/presentation/widgets/loading_animations.dart';
import '../../helpers/color_manager.dart';
import '../../helpers/text_styles.dart';
import 'session_action_button.dart';

class RecentSession extends StatelessWidget {
  const RecentSession({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
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
              /// Header row
              Row(
                children: [
                  Text(
                    'Recent Sessions',
                    style: TextStyles.font16BlackSemiBold,
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: ColorManager.mainGreen.withValues(
                        alpha: 0.08,
                      ),
                      foregroundColor: ColorManager.mainGreen,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
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
                        Icon(
                          Icons.add_circle_rounded,
                          size: 16.sp,
                          color: ColorManager.mainGreen,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12.h),

              /// Body
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 4.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
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
                  child: BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      if (state is GenerateTextLoadingState) {
                        return buildLoadingAnimation();
                        // return Center(
                        //   child: LoadingAnimationWidget.fallingDot(
                        //     color: ColorManager.darkGrey,
                        //     size: 70,
                        //   ),
                        // );
                      } else if (state is GenerateTextSuccessState) {
                        return SingleChildScrollView(
                          child: Center(
                            child: Text(
                              state.generatedText,

                              style: TextStyles.font14GreyRegular.copyWith(
                                fontSize: 15.sp,
                                height: 2,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                          ),
                        );
                      }
                      else if (state is GenerateTextErrorState) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline, color: Colors.red, size: 40),
                                const SizedBox(height: 12),
                                Text(
                                  state.error,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.font14GreyRegular.copyWith(
                                    fontSize: 16,
                                    color: Colors.red.shade600,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5, // 👈 spacing between lines
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // retry last request
                                    final cubit = HomeCubit.get(context);
                                    if (cubit.displayedText == null) {
                                      cubit.generatePracticeText(
                                        GenerateTextRequest(
                                          language: cubit.selectedLanguage,
                                          level: cubit.selectedLevel,
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text("Retry"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      else {
                        return Center(
                          child: Text(
                            cubit.displayedText ?? "Start your new session",
                            style: TextStyles.font14GreyRegular,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),

              SizedBox(height: 10.h),
              // if text is generated .. switch to RecordingButton
              BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  final cubit = HomeCubit.get(context);

                  return SessionActionButton(
                    isRecordingAvailable: state is GenerateTextSuccessState,
                    onGenerate: () {
                      final request = GenerateTextRequest(
                        language: cubit.selectedLanguage,
                        level: cubit.selectedLevel,
                      );
                      cubit.generatePracticeText(request);
                    },
                    onRecord: () {
                      debugPrint("🎙️ Start recording...");
                    },
                  );
                },
              ),




            ],
          ),
        ),
      ),
    );
  }
}
