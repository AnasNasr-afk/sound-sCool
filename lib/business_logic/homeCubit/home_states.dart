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
  final String errorMessage;
  final String errorType;

  GenerateTextErrorState({
    required this.errorMessage,
    required this.errorType,
  });
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

// Session Tracking States
class SessionStatsLoadedState extends HomeStates {
  final int sessions;
  final int recordings;
  SessionStatsLoadedState(this.sessions, this.recordings);
}

class SessionCompletedState extends HomeStates {
  final int totalSessions;
  SessionCompletedState(this.totalSessions);
}

class SessionStatsErrorState extends HomeStates {}

class SavingRecordingState extends HomeStates {}

class SessionCompletedErrorState extends HomeStates {
  final String error;
  SessionCompletedErrorState(this.error);
}
class RecordingStateResetState extends HomeStates {}