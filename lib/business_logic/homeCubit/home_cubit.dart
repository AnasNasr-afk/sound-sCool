import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/models/generate_text_request.dart';
import '../../data/networking/api_service.dart';
import '../../helpers/session_tracking_helper.dart';
import 'home_states.dart';

enum Stage { generate, record, analyze }

class HomeCubit extends Cubit<HomeStates> {
  final ApiService apiService;

  HomeCubit(this.apiService) : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  // ===== App State =====
  String? displayedText;
  String selectedLanguage = "German";
  bool isAnalyzing = false;

  final languages = {"English": "en-US", "German": "de-DE"};

  String selectedLevel = "A2";
  String? expandedSection;

  // ===== Session Tracking =====
  int completedSessions = 0;
  int totalRecordings = 0;

  // ===== Recording Stage =====
  bool isRecording = false;
  stt.SpeechToText? _speech;
  String currentRecognizedWords = '';
  String? finalRecordedText;
  bool _hasFinalResult = false;
  double currentSoundLevel = 0.0;

  // ===== Timer for Recording =====
  Timer? _recordingTimer;
  int _elapsedSeconds = 0;
  final int _maxRecordingSeconds = 30;

  String get timerDisplay {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds / 0:$_maxRecordingSeconds";
  }

  void _startRecordingTimer() {
    _elapsedSeconds = 0;
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      emit(RecordInProgressState(currentRecognizedWords));

      if (_elapsedSeconds >= _maxRecordingSeconds) {
        stopRecording();
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _elapsedSeconds = 0;
  }

  // ==================== Session Tracking ====================
  Future<void> loadSessionStats() async {
    completedSessions = await SessionTrackingHelper.getCompletedSessions();
    totalRecordings = await SessionTrackingHelper.getTotalRecordings();
    emit(SessionStatsLoadedState(completedSessions, totalRecordings));
  }

  Future<void> completeSession() async {
    await SessionTrackingHelper.incrementSession();
    completedSessions = await SessionTrackingHelper.getCompletedSessions();
    emit(SessionCompletedState(completedSessions));
  }

  // ==================== Generate Stage ====================
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

  // ==================== Recording Stage ====================
  Future<void> initSpeech() async {
    _speech ??= stt.SpeechToText();

    bool available = await _speech!.initialize(
      onError: (error) {
        print('Speech recognition error: ${error.errorMsg}');

        if (error.errorMsg.contains('timeout') && isRecording) {
          print('Timeout detected, restarting...');
          Future.delayed(const Duration(milliseconds: 500), () {
            if (isRecording && _elapsedSeconds < _maxRecordingSeconds) {
              _restartListening();
            }
          });
        } else if (!error.errorMsg.contains('timeout') && isRecording) {
          emit(RecordErrorState("Recognition error: ${error.errorMsg}"));
        }
      },
      onStatus: (status) {
        print('Speech status: $status');

        if (status == 'done' && isRecording && _elapsedSeconds < _maxRecordingSeconds) {
          print('Speech done, restarting...');
          Future.delayed(const Duration(milliseconds: 300), () {
            if (isRecording) {
              _restartListening();
            }
          });
        }
      },
    );

    if (!available) {
      emit(RecordErrorState("Speech recognition not available"));
    }
  }

  Future<void> _restartListening() async {
    if (_speech == null || !isRecording) return;

    String localeCode = languages[selectedLanguage] ?? "en-US";

    _speech!.listen(
      onResult: (result) {
        if (result.recognizedWords.isNotEmpty) {
          String newWords = result.recognizedWords;

          if (currentRecognizedWords.isEmpty) {
            currentRecognizedWords = newWords;
          } else if (newWords.contains(currentRecognizedWords)) {
            currentRecognizedWords = newWords;
          } else if (!currentRecognizedWords.contains(newWords)) {
            currentRecognizedWords += ' ' + newWords;
          }
        }

        if (result.finalResult) {
          _hasFinalResult = true;
        }

        emit(RecordInProgressState(currentRecognizedWords));
      },
      onSoundLevelChange: (level) {
        currentSoundLevel = level;
        emit(SoundLevelChangedState(level));
      },
      listenFor: Duration(seconds: _maxRecordingSeconds - _elapsedSeconds),
      pauseFor: const Duration(seconds: 10),
      localeId: localeCode,
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
        cancelOnError: false,
        onDevice: false,
        listenMode: stt.ListenMode.dictation,
      ),
    );
  }

  Future<void> startRecording() async {
    if (_speech == null) await initSpeech();

    finalRecordedText = null;
    bool hasPermission = await Permission.microphone.request().isGranted;
    if (!hasPermission) {
      emit(RecordErrorState("Microphone permission denied"));
      return;
    }

    isRecording = true;
    _hasFinalResult = false;
    currentRecognizedWords = '';
    emit(RecordInProgressState(currentRecognizedWords));

    _startRecordingTimer();
    await _restartListening();
  }

  Future<void> stopRecording() async {
    if (_speech == null || !isRecording) return;

    await _speech!.stop();
    isRecording = false;
    _stopRecordingTimer();

    currentSoundLevel = 0.0;
    emit(SoundLevelChangedState(0.0));

    String finalText = currentRecognizedWords.isEmpty
        ? _speech!.lastRecognizedWords
        : currentRecognizedWords;

    finalText = _cleanupRecognizedText(finalText);
    finalRecordedText = finalText;

    // Increment recording count
    await SessionTrackingHelper.incrementRecording();
    totalRecordings = await SessionTrackingHelper.getTotalRecordings();

    emit(RecordSuccessState(finalText));
  }

  String _cleanupRecognizedText(String text) {
    if (text.isEmpty) return text;

    text = text[0].toUpperCase() + text.substring(1);

    if (!text.endsWith('.') && !text.endsWith('?') && !text.endsWith('!')) {
      text += '.';
    }

    return text;
  }

  // ==================== UI State Management ====================
  void toggleSection(String section) {
    expandedSection = expandedSection == section ? null : section;
    emit(SectionToggledState(expandedSection));
  }

  void selectLanguage(String languageName) {
    selectedLanguage = languageName;
    expandedSection = null;
    emit(LanguageSelectedState(languageName));
  }

  void selectLevel(String level) {
    selectedLevel = level;
    expandedSection = null;
    emit(LevelSelectedState(level));
  }

  Stage currentStage = Stage.generate;

  void goToStage(Stage stage) {
    currentStage = stage;
    emit(StageChangedState(stage));
  }

  @override
  Future<void> close() async {
    _stopRecordingTimer();
    if (isRecording) {
      await _speech?.stop();
    }
    return super.close();
  }
}