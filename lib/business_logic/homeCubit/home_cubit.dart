import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/generate_text_request.dart';
import '../../data/networking/api_service.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final ApiService apiService;
  HomeCubit(this.apiService) : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  String? displayedText;
  String selectedLanguage = "German";
  String selectedLevel = "A2";
  String? expandedSection;

  Future<void> generatePracticeText(GenerateTextRequest request) async {
    emit(GenerateTextLoadingState());
    try {
      final response = await apiService.generateText(request);
      displayedText = response.text;
      emit(GenerateTextSuccessState(response.text));
    } catch (e) {
      String errorMessage = "Something went wrong. Please try again.";

      if (e.toString().contains("RESOURCE_EXHAUSTED")) {
        errorMessage = "Daily free limit reached. Try again tomorrow or upgrade your plan.";
      } else if (e.toString().contains("NETWORK")) {
        errorMessage = "Check your internet connection.";
      }

      emit(GenerateTextErrorState(errorMessage));
    }
  }

  void toggleSection(String section) {
    expandedSection = expandedSection == section ? null : section;
    emit(SectionToggledState(expandedSection));
  }

  void selectLanguage(String language) {
    selectedLanguage = language;
    expandedSection = null;
    emit(LanguageSelectedState(language));
  }

  void selectLevel(String level) {
    selectedLevel = level;
    expandedSection = null;
    emit(LevelSelectedState(level));
  }
}
