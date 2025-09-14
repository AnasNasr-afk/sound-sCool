abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

// Text Generation States
class GenerateTextLoadingState extends HomeStates {}

class GenerateTextSuccessState extends HomeStates {
  final String generatedText;
  GenerateTextSuccessState(this.generatedText);
}

class GenerateTextErrorState extends HomeStates {
  final String error;
  GenerateTextErrorState(this.error);
}

// UI Selection States
class LanguageSelectedState extends HomeStates {
  final String language;
  LanguageSelectedState(this.language);
}

class LevelSelectedState extends HomeStates {
  final String level;
  LevelSelectedState(this.level);
}

class SectionToggledState extends HomeStates {
  final String? expandedSection;
  SectionToggledState(this.expandedSection);
}

// Audio Recording States
class SpeechListeningState extends HomeStates {}

class SpeechPartialResultState extends HomeStates {
  final String partialText;
  SpeechPartialResultState(this.partialText);
}




class SpeechStoppedState extends HomeStates {
  final String? audioFilePath;
  SpeechStoppedState([this.audioFilePath]);
}

class SpeechCancelledState extends HomeStates {}

class SpeechErrorState extends HomeStates {
  final String error;
  SpeechErrorState(this.error);
}

// Recording Timer State
class SpeechTimerTickState extends HomeStates {
  final String formattedTime;
  SpeechTimerTickState(this.formattedTime);
}

// Pronunciation Analysis States (for future use)
class PronunciationAnalysisLoadingState extends HomeStates {}

class PronunciationResultState extends HomeStates {
  final String recognizedText;
  final List<bool> wordAnalysis; // true = correct, false = incorrect
  final double accuracy;
  final Map<int, bool> wordResults; // index -> correct/incorrect

  PronunciationResultState({
    required this.recognizedText,
    required this.wordAnalysis,
    required this.accuracy,
    required this.wordResults,
  });
}


class PronunciationAnalysisErrorState extends HomeStates {
  final String error;
  PronunciationAnalysisErrorState(this.error);
}