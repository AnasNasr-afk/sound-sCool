import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/textRecordAnalyzeWidet/widgets/components/placeholder_container.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../data/models/generate_text_request.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/components.dart';
import '../components/action_button.dart';
import '../components/text_card.dart';

class TextGeneratingStage extends StatelessWidget {
  const TextGeneratingStage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeStates>(

      listener: (context, state) {
        if (state is GenerateTextErrorState) {
          // Show specific error message
          if (state.errorType == 'RATE_LIMIT') {
            GenerationLimitDialog.show(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(
                      _getErrorIcon(state.errorType),
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(state.errorMessage),
                    ),
                  ],
                ),
                backgroundColor: Colors.red.shade600,
                duration: Duration(seconds: 4),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                action: state.errorType == 'NO_INTERNET' ||
                    state.errorType == 'TIMEOUT' ||
                    state.errorType == 'NETWORK_ERROR'
                    ? SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: () {
                    final cubit = HomeCubit.get(context);
                    final request = GenerateTextRequest(
                      language: cubit.selectedLanguage,
                      level: cubit.selectedLevel,
                    );
                    cubit.generatePracticeText(request);
                  },
                )
                    : null,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        // Loading
        if (state is GenerateTextLoadingState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: ColorManager.mainGreen),
                SizedBox(height: 12.h),
                Text(
                  'Generating practice text...',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          );
        }

        // Error
        if (state is GenerateTextErrorState) {
          return Column(
            children: [
              Expanded(
                child: PlaceholderContainer(
                  icon: _getErrorIcon(state.errorType),
                  title: _getErrorTitle(state.errorType),
                  subtitle: state.errorMessage,
                ),
              ),
              SizedBox(height: 16.h),
              if (state.errorType != 'RATE_LIMIT') // Don't show retry for rate limit
                ActionButton(
                  label: 'Try Again',
                  icon: Icons.refresh,
                  onPressed: () {
                    final request = GenerateTextRequest(
                      language: cubit.selectedLanguage,
                      level: cubit.selectedLevel,
                    );
                    cubit.generatePracticeText(request);
                  },
                ),
            ],
          );
        }

        // Success: display generated text + option to move to recording
        if (state is GenerateTextSuccessState) {
          return Column(
            children: [
              Expanded(child: TextCard(text: state.generatedText)),
              SizedBox(height: 16.h),
              ActionButton(
                label: 'Start Recording',
                icon: Icons.arrow_forward,
                onPressed: () {
                  cubit.goToStage(Stage.record);
                },
              ),
            ],
          );
        }

        // Default (initial, no text yet)

        return Column(
          children: [
            const Expanded(
              child: PlaceholderContainer(
                icon: Icons.auto_awesome,
                title: 'Ready to generate',
                subtitle: 'Tap the button below to create practice text.',
              ),
            ),

            // if (cubit.isGenerationLimitReached)
            //   Container(
            //     height: 28.h,
            //     decoration: BoxDecoration(
            //       color: ColorManager.mainBlack,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(16.r),
            //         topRight: Radius.circular(16.r),
            //         bottomLeft: Radius.circular(10.r),
            //         bottomRight: Radius.circular(10.r),
            //       ),
            //     ),
            //     alignment: Alignment.center,
            //     child: Row(
            //       children: [
            //         Text(
            //           'Session limit reached • Resets 12:00 AM',
            //           style: TextStyle(color: Colors.white, fontSize: 12.sp),
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ActionButton(
            //   label: 'Generate Text',
            //   icon: Icons.auto_awesome,
            //   backgroundColor: cubit.isGenerationLimitReached
            //       ? ColorManager.mainGreen.withValues(alpha: 0.5)
            //       : ColorManager.mainGreen ,
            //   onPressed: cubit.isGenerationLimitReached
            //       ? null
            //       : () {
            //     final request = GenerateTextRequest(
            //       language: cubit.selectedLanguage,
            //       level: cubit.selectedLevel,
            //     );
            //     cubit.generatePracticeText(request);
            //   },
            // ),


            ActionButton(
              label: 'Generate Text',
              icon: Icons.auto_awesome,
              onPressed: () {
                final request = GenerateTextRequest(
                language: cubit.selectedLanguage,
                level: cubit.selectedLevel,
              );
              cubit.generatePracticeText(request);
              },
            ),




          ],
        );
      },
    );
  }

  IconData _getErrorIcon(String errorType) {
    switch (errorType) {
      case 'NO_INTERNET':
      case 'NETWORK_ERROR':
        return Icons.wifi_off;
      case 'TIMEOUT':
        return Icons.timer_off;
      case 'SERVER_ERROR':
        return Icons.cloud_off;
      case 'RATE_LIMIT':
        return Icons.block;
      case 'API_KEY_ERROR':
        return Icons.key_off;
      default:
        return Icons.error_outline;
    }
  }

  String _getErrorTitle(String errorType) {
    switch (errorType) {
      case 'NO_INTERNET':
        return 'No Internet';
      case 'NETWORK_ERROR':
        return 'Network Error';
      case 'TIMEOUT':
        return 'Request Timeout';
      case 'SERVER_ERROR':
        return 'Server Error';
      case 'RATE_LIMIT':
        return 'Daily Limit Reached';
      case 'API_KEY_ERROR':
        return 'Configuration Error';
      default:
        return 'Error';
    }
  }
}