import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../business_logic/homeCubit/home_cubit.dart';
import '../../../business_logic/homeCubit/home_states.dart';
import '../../../data/models/generate_text_request.dart';
import '../../../helpers/color_manager.dart';
import '../../../helpers/text_styles.dart';

class TextGenerationErrorView extends StatelessWidget {
  final String error;

  const TextGenerationErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyles.font14GreyRegular.copyWith(
                fontSize: 16,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                final cubit = HomeCubit.get(context);
                cubit.generatePracticeText(
                  GenerateTextRequest(
                    language: cubit.selectedLanguage,
                    level: cubit.selectedLevel,
                  ),
                );
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
}

class RecordingErrorView extends StatelessWidget {
  final String error;

  const RecordingErrorView({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mic_off, color: Colors.red, size: 40),
            const SizedBox(height: 12),
            Text(
              'Recording Error',
              style: TextStyles.font14GreyRegular.copyWith(
                fontSize: 16,
                color: Colors.red.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyles.font14GreyRegular.copyWith(
                fontSize: 14,
                color: Colors.red.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalysisLoadingView extends StatelessWidget {
  const AnalysisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorManager.mainGreen),
          SizedBox(height: 16.h),
          Text(
            'Analyzing your pronunciation...',
            style: TextStyles.font14GreyRegular.copyWith(
              color: ColorManager.darkGrey,
            ),
          ),
        ],
      ),
    );
  }
}

// class PronunciationResultsView extends StatelessWidget {
//   final HomeCubit cubit;
//   final PronunciationResultState state;
//
//   const PronunciationResultsView({
//     super.key,
//     required this.cubit,
//     required this.state,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Accuracy: ${(state.accuracy * 100).toStringAsFixed(0)}%',
//             style: TextStyles.font14GreyRegular.copyWith(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w600,
//               color: ColorManager.mainGreen,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           // TODO: Show highlighted text with correct/incorrect words
//           Text(
//             'Pronunciation results will be shown here',
//             style: TextStyles.font14GreyRegular,
//           ),
//         ],
//       ),
//     );
//   }
// }
