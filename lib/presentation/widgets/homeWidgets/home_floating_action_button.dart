import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sounds_cool/presentation/widgets/homeWidgets/session_action_button.dart';

import '../../../business_logic/homeCubit/home_cubit.dart';
import '../../../business_logic/homeCubit/home_states.dart';
import '../../../data/models/generate_text_request.dart';

class HomeFloatingActionButton extends StatelessWidget {
  const HomeFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        // Fixed state mapping logic
        ActionState actionState = ActionState.idle;

        // Check if currently recording (including timer ticks)
        if (state is SpeechListeningState || state is SpeechTimerTickState) {
          actionState = ActionState.recording;
        }
        // Show mic when text is ready and not in processing states
        else if (cubit.displayedText != null &&
            state is! GenerateTextLoadingState &&
            state is! PronunciationAnalysisLoadingState &&
            state is! PronunciationResultState) {
          actionState = ActionState.mic;
        }
        // Show generate button when no text or in loading states
        else {
          actionState = ActionState.idle;
        }

        return state is SpeechStoppedState ?SizedBox.shrink() :   SessionActionButton(
          actionState: actionState,
          onGenerate: () {
            final request = GenerateTextRequest(
              language: cubit.selectedLanguage,
              level: cubit.selectedLevel,
            );
            cubit.generatePracticeText(request);
          },
          onMic: () {
            debugPrint("🎙️ Starting recording");
            cubit.startRecording();
          },
          onStop: () {
            debugPrint("⏹️ Stopping recording");
            cubit.stopRecording();
          },
        )  ;
      },
    );
  }
}