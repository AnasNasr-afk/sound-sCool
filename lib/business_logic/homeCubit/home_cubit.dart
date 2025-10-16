import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/models/generate_text_request.dart';
import '../../data/networking/api_service.dart';
import '../../data/networking/user_limits_service.dart';
import 'home_states.dart';

enum Stage { generate, record, analyze }

class HomeCubit extends Cubit<HomeStates> {
  final ApiService apiService;
  final UserLimitsService limitsService;
  final String userId;

  HomeCubit(this.apiService, this.limitsService, this.userId)
      : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  // ===== App State =====
  String? displayedText;
  String selectedLanguage = "German";
  bool isAnalyzing = false;

  final languages = {
    "English": "en-US",
    "German": "de-DE",
    "Italian": "it-IT",
    "French": "fr-FR",
    "Spanish": "es-ES",
  };

  String selectedLevel = "A2";
  String? expandedSection;

  // ===== Session Tracking (from Firestore) =====
  int monthlyCompletedSessions = 0;  // Increments EVERY time user completes 3 stages
  int dailyRecordings = 0;
  int dailyGenerations = 0;
  bool isGenerationLimitReached = false;
  File? _currentAudioFile;

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

  // ==================== Session Tracking (Firestore) ====================
  Future<void> loadSessionStats() async {
    try {
      final limits = await limitsService.getUserLimits(userId);
      monthlyCompletedSessions = await limitsService.getMonthlySessionCount(userId);

      dailyRecordings = limits['recordings'];
      dailyGenerations = limits['generations'];

      isGenerationLimitReached = dailyGenerations >= 7;

      emit(SessionStatsLoadedState(monthlyCompletedSessions, dailyRecordings));
    } catch (e) {
      print('Error loading session stats: $e');
      emit(SessionStatsErrorState());
    }
  }

  // ==================== Generate Stage ====================
  Future<void> generatePracticeText(GenerateTextRequest request) async {
    emit(GenerateTextLoadingState());
    try {
      dailyGenerations = await limitsService.incrementGeneration(userId);

      isGenerationLimitReached = dailyGenerations >= 7;
      final response = await apiService.generateText(request);
      displayedText = response.text;
      emit(GenerateTextSuccessState(response.text));
    } catch (e) {
      String errorMessage = "Something went wrong. Please try again.";
      String errorType = "UNKNOWN";

      if (e.toString().contains('RATE_LIMIT')) {
        errorMessage = "Daily limit reached. Try again tomorrow or upgrade for unlimited generations.";
        errorType = "RATE_LIMIT";
      } else if (e.toString().contains('NO_INTERNET')) {
        errorMessage = "No internet connection. Please check your network.";
        errorType = "NO_INTERNET";
      } else if (e.toString().contains('TIMEOUT')) {
        errorMessage = "Request timed out. Please try again.";
        errorType = "TIMEOUT";
      } else if (e.toString().contains('SERVER_ERROR')) {
        errorMessage = "Server is busy. Please try again in a moment.";
        errorType = "SERVER_ERROR";
      } else if (e.toString().contains('API_KEY_ERROR')) {
        errorMessage = "Configuration error. Please contact support.";
        errorType = "API_KEY_ERROR";
      } else if (e.toString().contains('NETWORK_ERROR')) {
        errorMessage = "Network error. Check your connection and try again.";
        errorType = "NETWORK_ERROR";
      }

      emit(GenerateTextErrorState(
        errorMessage: errorMessage,
        errorType: errorType,
      ));
    }
  }

  Future<bool> canGenerateToday() async {
    return await limitsService.canGenerate(userId);
  }

  // ==================== Recording Stage ====================
  Future<void> initSpeech() async {
    _speech ??= stt.SpeechToText();

    bool available = await _speech!.initialize(
      onError: (error) {
        if (error.errorMsg.contains('timeout') && isRecording) {
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
        if (status == 'done' && isRecording && _elapsedSeconds < _maxRecordingSeconds) {
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
            currentRecognizedWords += ' $newWords';
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

    try {
      dailyRecordings = await limitsService.incrementRecording(userId);
    } catch (e) {
      print('Error incrementing recording: $e');
    }

    emit(RecordSuccessState(finalText));
  }

  Future<bool> canRecordToday() async {
    return await limitsService.canRecord(userId);
  }

  String _cleanupRecognizedText(String text) {
    if (text.isEmpty) return text;
    text = text[0].toUpperCase() + text.substring(1);
    if (!text.endsWith('.') && !text.endsWith('?') && !text.endsWith('!')) {
      text += '.';
    }
    return text;
  }

  // ==================== COMPLETE SESSION (INCREMENTS MONTHLY COUNTER!) ====================
  Future<void> completeSession() async {
    try {
      // Increment monthly session counter
      monthlyCompletedSessions = await limitsService.incrementSession(userId);

      emit(SessionCompletedState(monthlyCompletedSessions));
    } catch (e) {
      print('Error completing session: $e');
    }
  }

  // ==================== RESET RECORDING STATE ====================
  /// Call this when starting a new session to clear all recording data
  void resetRecordingState() {
    currentRecognizedWords = '';
    finalRecordedText = null;
    _hasFinalResult = false;
    currentSoundLevel = 0.0;
    isRecording = false;
    _stopRecordingTimer();

    // Emit state to update UI
    emit(RecordingStateResetState());
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
    // Reset recording state when going back to generate stage (new session)
    if (stage == Stage.generate) {
      resetRecordingState();
    }

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