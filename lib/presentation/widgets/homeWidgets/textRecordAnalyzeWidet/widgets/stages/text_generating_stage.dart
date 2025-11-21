import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/helpers/text_styles.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/textRecordAnalyzeWidet/widgets/components/placeholder_container.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../data/models/generate_text_request.dart';
import '../../../../../../helpers/color_manager.dart';
import '../../../../../../helpers/components.dart';
import '../components/action_button.dart';
import '../components/secondary_action_button.dart';
import '../components/text_card.dart';

class TextGeneratingStage extends StatelessWidget {
  const TextGeneratingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: _handleStateListener,
      builder: (context, state) => _buildContent(context, state),
    );
  }

  // === Listeners ===
  void _handleStateListener(BuildContext context, HomeStates state) {
    if (state is GenerateTextErrorState) {
      if (state.errorType == 'RATE_LIMIT') {
        GenerationLimitDialog.show(context);
      } else {
        _showErrorSnackBar(context, state);
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, GenerateTextErrorState state) {
    final isNetworkError = ['NO_INTERNET', 'TIMEOUT', 'NETWORK_ERROR']
        .contains(state.errorType);

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
            Expanded(child: Text(state.errorMessage)),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        action: isNetworkError
            ? SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => _retryGeneration(context),
        )
            : null,
      ),
    );
  }

  // === Builders ===
  Widget _buildContent(BuildContext context, HomeStates state) {
    return switch (state) {
      GenerateTextLoadingState() => _buildLoadingState(),
      GenerateTextErrorState() => _buildErrorState(context, state),
      GenerateTextSuccessState() => _buildSuccessState(context, state),
      _ => _buildInitialState(context),
    };
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorManager.mainGreen),
          SizedBox(height: 12.h),
          Text(
            'Generating practice text...',

            style: TextStyles.font14GreyRegular.copyWith(
              color: ColorManager.mainBlack,
              fontSize: 14.sp,
            ),
            // TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, GenerateTextErrorState state) {
    final shouldShowRetry = state.errorType != 'RATE_LIMIT';

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
        if (shouldShowRetry)
          ActionButton(
            label: 'Try Again',
            icon: Icons.refresh,
            onPressed: () => _retryGeneration(context),
          ),
      ],
    );
  }

  Widget _buildSuccessState(
      BuildContext context,
      GenerateTextSuccessState state,
      ) {
    return Column(
      children: [
        // Text card expands to fill available space; badge is positioned inside it
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Fill the stack with the TextCard
              Positioned.fill(
                child: TextCard(text: state.generatedText),
              ),

              // Badge at bottom-right, inset inside the card
              Positioned(
                bottom: 0.h,
                right: 0.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: ColorManager.mainGreen.withValues(alpha: 0.10),
                    border: Border.all(
                      color: ColorManager.mainGreen.withValues(alpha: 0.28),
                      width: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.auto_awesome,
                        size: 12.sp,
                        color: ColorManager.mainGreen,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'AI Generated',
                        style: TextStyle(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.mainGreen,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),
        _buildActionButtonsRow(context),
        SizedBox(height: 16.h),
        ActionButton(
          label: 'Go to recording stage',
          onPressed: () => HomeCubit.get(context).goToStage(Stage.record),
        ),
      ],
    );
  }


  Widget _buildInitialState(BuildContext context) {
    final cubit = HomeCubit.get(context);
    final isLimitReached = cubit.isGenerationLimitReached;

    return Column(
      children: [
        const Expanded(
          child: PlaceholderContainer(
            icon: Icons.auto_awesome,
            title: 'Ready to generate',
            subtitle: 'Tap the button below to start practicing.',
          ),
        ),
        if (isLimitReached) _buildDailyLimitBanner(context),
        ActionButton(
          label: 'Generate Text',
          icon: Icons.auto_awesome,
          backgroundColor: isLimitReached
              ? ColorManager.mainGreen.withValues(alpha: 0.4)
              : null,
          onPressed: isLimitReached ? null : () => _handleGeneratePressed(context),
        ),
      ],
    );
  }

  // === Action Buttons ===
  Widget _buildActionButtonsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SecondaryActionButton(
            label: 'Try Again',
            icon: Icons.refresh,
            backgroundColor: Colors.transparent,
            borderColor: ColorManager.mainGreen,
            textColor: ColorManager.mainBlack,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: SecondaryActionButton(
            label: 'Dismiss',
            icon: Icons.close,
            onPressed: () => _dismissResult(context),
            backgroundColor: ColorManager.mainGrey,
            borderColor: ColorManager.mainGrey,
            textColor: ColorManager.mainBlack,
          )
        ),
      ],
    );
  }



  Widget _buildDailyLimitBanner(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => GenerationLimitDialog.show(context),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            decoration: BoxDecoration(
              color: ColorManager.mainBlack,
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Daily limit reached',
                        style: TextStyle(
                          color: ColorManager.whiter,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Resets at 12:00 AM',
                        style: TextStyle(
                          color: ColorManager.whiter.withValues(alpha: 0.7),
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Upgrade',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // === Action Handlers ===
  Future<void> _handleGeneratePressed(BuildContext context) async {
    final cubit = HomeCubit.get(context);
    final canGenerate = await cubit.canGenerateToday();

    if (!canGenerate) {
      if (context.mounted) {
        GenerationLimitDialog.show(context);
      }
      return;
    }

    _generateText(context);
  }

  void _generateText(BuildContext context) {
    final cubit = HomeCubit.get(context);
    final request = GenerateTextRequest(
      language: cubit.selectedLanguage,
      level: cubit.selectedLevel,
    );
    cubit.generatePracticeText(request);
  }

  void _retryGeneration(BuildContext context) => _generateText(context);

  void _dismissResult(BuildContext context) {
    final cubit = HomeCubit.get(context);
    cubit.goToStage(Stage.generate);
  }

  // === Helper Methods ===
  IconData _getErrorIcon(String errorType) => switch (errorType) {
    'NO_INTERNET' || 'NETWORK_ERROR' => Icons.wifi_off,
    'TIMEOUT' => Icons.timer_off,
    'SERVER_ERROR' => Icons.cloud_off,
    'RATE_LIMIT' => Icons.block,
    'API_KEY_ERROR' => Icons.key_off,
    _ => Icons.error_outline,
  };

  String _getErrorTitle(String errorType) => switch (errorType) {
    'NO_INTERNET' => 'No Internet',
    'NETWORK_ERROR' => 'Network Error',
    'TIMEOUT' => 'Request Timeout',
    'SERVER_ERROR' => 'Server Error',
    'RATE_LIMIT' => 'Daily Limit Reached',
    'API_KEY_ERROR' => 'Configuration Error',
    _ => 'Error',
  };
}

