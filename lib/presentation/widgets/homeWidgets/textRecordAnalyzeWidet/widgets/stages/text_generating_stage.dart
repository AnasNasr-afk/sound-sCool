import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/textRecordAnalyzeWidet/widgets/components/placeholder_container.dart';
import '../../../../../../business_logic/homeCubit/home_cubit.dart';
import '../../../../../../business_logic/homeCubit/home_states.dart';
import '../../../../../../data/models/generate_text_request.dart';
import '../../../../../../helpers/color_manager.dart';
import '../components/action_button.dart';
import '../components/text_card.dart';

class TextGeneratingStage extends StatelessWidget {
  const TextGeneratingStage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is GenerateTextSuccessState) {
          // ScaffoldMessenger.of(context).showSnackBar( // const SnackBar(content: Text('Practice text generated')), // );
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
        } // Error
        if (state is GenerateTextErrorState) {
          return const PlaceholderContainer(
            icon: Icons.error_outline,
            title: 'Error',
            subtitle: 'Failed to generate text. Try again.',
          );
        } // Success: display generated text + option to move to recording
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

                  // ✅ switch stage here
                },
              ),
            ],
          );
        } // Default (initial, no text yet)
        return Column(
          children: [
            const Expanded(
              child: PlaceholderContainer(
                icon: Icons.auto_awesome,
                title: 'Ready to generate',
                subtitle: 'Tap the button below to create practice text.',
              ),
            ),
            SizedBox(height: 16.h),
            ActionButton(
              label: 'Generate Text',
              icon: Icons.auto_awesome,
              onPressed: () {
                final request = GenerateTextRequest(
                  language: cubit.selectedLanguage,
                  level: cubit.selectedLevel,
                );
                cubit.generatePracticeText(request); // ✅ just generate here
              },
            ),
          ],
        );
      },
    );
  }
}
