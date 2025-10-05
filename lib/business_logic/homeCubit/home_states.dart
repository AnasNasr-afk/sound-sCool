import 'home_cubit.dart';

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

// Recording States
class RecordInProgressState extends HomeStates {
  final String text;
  RecordInProgressState(this.text);
}

class RecordSuccessState extends HomeStates {
  final String text;
  RecordSuccessState(this.text);
}

class RecordErrorState extends HomeStates {
  final String error;
  RecordErrorState(this.error);
}

class SpeechTimerTickState extends HomeStates {
  final int seconds;
  SpeechTimerTickState(this.seconds);
}

class StageChangedState extends HomeStates {
  final Stage stage;
  StageChangedState(this.stage);
}

class SoundLevelChangedState extends HomeStates {
  final double level;
  SoundLevelChangedState(this.level);
}