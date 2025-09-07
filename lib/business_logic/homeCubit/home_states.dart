abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class GenerateTextLoadingState extends HomeStates {}

class GenerateTextSuccessState extends HomeStates {
  final String generatedText;
  GenerateTextSuccessState(this.generatedText);
}

class GenerateTextErrorState extends HomeStates {
  final String error;
  GenerateTextErrorState(this.error);
}

/// 🔹 New states for UI updates
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
