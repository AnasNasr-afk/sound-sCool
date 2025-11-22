import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../data/models/generate_text_request.dart';
import '../../data/networking/api_service.dart';
import '../../data/networking/user_limits_service.dart';
import 'home_states.dart';

enum Stage { generate, record, analyze }
enum ConnectivityStatus { online, offline }

/// Production-ready HomeCubit with safer recording flow, permission handling,
/// connectivity debounce, and guarded debug logging.
class HomeCubit extends Cubit<HomeStates> {
  final ApiService apiService;
  final UserLimitsService limitsService;
  final String userId;
  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;
  Timer? _connectivityDebounce; // debounce connectivity events

  HomeCubit(
      this.apiService,
      this.limitsService,
      this.userId, {
        Connectivity? connectivity,
      })  : _connectivity = connectivity ?? Connectivity(),
        super(HomeInitialState()) {
    _listenConnectivity();
  }

  static HomeCubit get(context) => BlocProvider.of(context);
  ConnectivityStatus _connectivityStatus = ConnectivityStatus.online;
  ConnectivityStatus get connectivityStatus => _connectivityStatus;

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

  // ===== Session Tracking =====
  int monthlyCompletedSessions = 0;
  int dailyRecordings = 0;
  int dailyGenerations = 0;
  bool isGenerationLimitReached = false;

  // ===== Recording Stage =====
  bool isRecording = false;
  stt.SpeechToText? _speech;
  String currentRecognizedWords = '';
  String? finalRecordedText;
  bool hasFinalResult = false;
  double currentSoundLevel = 0.0;

  // Guards to prevent concurrent operations
  bool _isListening = false;
  bool _isStopping = false;

  // ===== Timer for Recording =====
  Timer? _recordingTimer;
  int _elapsedSeconds = 0;
  final int _maxRecordingSeconds = 30;

  // ===== Generate Retry =====
  GenerateTextRequest? _lastGenerateRequest;

  // ==================== CONNECTIVITY ====================
  void _listenConnectivity() {
    if (kDebugMode) debugPrint("🔌 Listening to connectivity changes...");

    _connectivitySub = _connectivity.onConnectivityChanged.listen((results) {
      // debounce noisy events (connectivity_plus can be chatty)
      _connectivityDebounce?.cancel();
      _connectivityDebounce = Timer(const Duration(milliseconds: 300), () {
        try {
          if (kDebugMode) debugPrint("📡 Connectivity event: $results");

          final result =
          results.isNotEmpty ? results.first : ConnectivityResult.none;
          if (kDebugMode) debugPrint("➡️ Connectivity interpreted as: $result");

          final newStatus = (result == ConnectivityResult.none)
              ? ConnectivityStatus.offline
              : ConnectivityStatus.online;

          if (newStatus != _connectivityStatus) {
            if (kDebugMode) debugPrint("🌐 STATUS CHANGED: $newStatus");
            _connectivityStatus = newStatus;
            emit(ConnectivityChangedState(_connectivityStatus));
          } else {
            if (kDebugMode) debugPrint("ℹ️ Status unchanged, still: $_connectivityStatus");
          }
        } catch (e) {
          if (kDebugMode) debugPrint('connectivity handler error: \$e\n\$st');
        }
      });
    });
  }

  // ==================== TIMER ====================
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
        // guard: only call stopRecording if recording is still active
        if (isRecording && !_isStopping) {
          _isStopping = true;
          stopRecording().whenComplete(() => _isStopping = false);
        }
      }
    });
  }

  void _stopRecordingTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
    _elapsedSeconds = 0;
  }

  // ==================== SESSION TRACKING ====================
  Future<void> loadSessionStats() async {
    try {
      final limits = await limitsService.getUserLimits(userId);
      monthlyCompletedSessions =
      await limitsService.getMonthlySessionCount(userId);

      dailyRecordings = limits['recordings'];
      dailyGenerations = limits['generations'];

      isGenerationLimitReached = dailyGenerations >= 7;

      emit(SessionStatsLoadedState(monthlyCompletedSessions, dailyRecordings));
    } catch (e) {
      emit(SessionStatsErrorState());
    }
  }

  // ==================== GENERATE STAGE ====================
  Future<void> generatePracticeText(GenerateTextRequest request) async {
    _lastGenerateRequest = request;
    await _performGeneration(request);
  }

  Future<void> _performGeneration(GenerateTextRequest request) async {
    emit(GenerateTextLoadingState());
    try {
      dailyGenerations = await limitsService.incrementGeneration(userId);
      isGenerationLimitReached = dailyGenerations >= 7;

      final response = await apiService.generateText(request);
      displayedText = response.text;
      emit(GenerateTextSuccessState(response.text));
    } catch (e) {
      if (kDebugMode) debugPrint('Error generating text: $e');
      String errorMessage = "Something went wrong. Please try again.";
      String errorType = "UNKNOWN";

      if (e.toString().contains('RATE_LIMIT')) {
        errorMessage =
        "Daily limit reached. Try again tomorrow or upgrade for unlimited generations.";
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
        if (kDebugMode) debugPrint('API Key Error: $e');
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

  Future<void> retryLastGeneration() async {
    if (_lastGenerateRequest == null) {
      emit(GenerateTextErrorState(
        errorMessage: "No previous request to retry.",
        errorType: "UNKNOWN",
      ));
      return;
    }
    await _performGeneration(_lastGenerateRequest!);
  }

  Future<bool> canGenerateToday() async {
    return await limitsService.canGenerate(userId);
  }

  // ==================== SPEECH RECOGNITION ====================

  Future<void> initSpeech() async {
    if (kDebugMode) debugPrint('initSpeech: creating SpeechToText instance');
    _speech ??= stt.SpeechToText();

    final available = await _speech!.initialize(
      onError: (error) {
        if (kDebugMode) debugPrint('speech init onError: ${error.errorMsg}');
        // Only emit an error for serious (non-timeout) errors when recording
        if (!error.errorMsg.contains('timeout') && isRecording) {
          emit(RecordErrorState("Recognition error: ${error.errorMsg}"));
        }
      },
      onStatus: (status) {
        if (kDebugMode) debugPrint('speech onStatus: $status');
        if (status == 'done' && isRecording && _elapsedSeconds < _maxRecordingSeconds) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (isRecording) _restartListening();
          });
        }
      },
    );

    if (kDebugMode) debugPrint('initSpeech available: $available');
    if (!available) {
      // Important: don't open settings from the cubit. Emit an error state UI can react to.
      emit(RecordErrorState("Speech recognition not available on this device"));
    }
  }

  Future<void> _restartListening() async {
    // Guard: must have a SpeechToText instance and be actively recording
    if (_speech == null || !isRecording) {
      if (kDebugMode) debugPrint('[_restartListening] ignored: _speech=${_speech != null}, isRecording=$isRecording');
      return;
    }

    // Prevent concurrent listen() calls
    if (_isListening) {
      if (kDebugMode) debugPrint('[_restartListening] already listening - skip');
      return;
    }

    // compute remaining time
    final remainingSeconds = _maxRecordingSeconds - _elapsedSeconds;
    if (remainingSeconds <= 0) {
      if (kDebugMode) debugPrint('[_restartListening] no remaining time (elapsed=$_elapsedSeconds)');
      return;
    }

    final localeCode = languages[selectedLanguage] ?? 'en-US';
    if (kDebugMode) debugPrint('[_restartListening] starting listen (locale: $localeCode, remaining: $remainingSeconds)');

    try {
      _isListening = true;

      _speech!.listen(
        onResult: (result) {
          if (kDebugMode) debugPrint('speech onResult: "${result.recognizedWords}" final=${result.finalResult}');

          if (result.recognizedWords.isNotEmpty) {
            final newWords = result.recognizedWords;

            // merge logic: prefer the newest recognized content but avoid duplicates
            if (currentRecognizedWords.isEmpty) {
              currentRecognizedWords = newWords;
            } else if (newWords.contains(currentRecognizedWords)) {
              currentRecognizedWords = newWords;
            } else if (!currentRecognizedWords.contains(newWords)) {
              currentRecognizedWords = '$currentRecognizedWords $newWords';
            }
          }

          if (result.finalResult) {
            hasFinalResult = true;
            if (kDebugMode) debugPrint('speech final result received');
            // optionally stop automatically on final result (commented out)
            // stopRecording();
          }

          // update UI
          emit(RecordInProgressState(currentRecognizedWords));
        },
        onSoundLevelChange: (level) {
          currentSoundLevel = level;
          emit(SoundLevelChangedState(level));
        },
        listenFor: Duration(seconds: remainingSeconds),
        pauseFor: const Duration(seconds: 10),
        localeId: localeCode,
        listenOptions: stt.SpeechListenOptions(
          partialResults: true,
          cancelOnError: false,
          onDevice: false, // use cloud/system recognizer for maximum compatibility
          listenMode: stt.ListenMode.dictation,
        ),
      );

      // safety: ensure _isListening resets after expected listen period
      Future.delayed(Duration(seconds: remainingSeconds + 1), () {
        _isListening = false;
      });

      if (kDebugMode) debugPrint('[_restartListening] listen() called successfully');
    } catch (e, st) {
      if (kDebugMode) debugPrint('[_restartListening] listen() threw: $e\n$st');
      emit(RecordErrorState('Failed to start listening: ${e.toString()}'));
      _isListening = false;
    }
  }

  Future<void> startRecording() async {
    if (kDebugMode) debugPrint('startRecording: check/request microphone permission');

    try {
      if (await Permission.microphone.isPermanentlyDenied) {
        // Don't open settings directly from cubit. Emit an error so UI can show a dialog.
        emit(RecordErrorState("Microphone permission permanently denied. Please enable in app settings."));
        return;
      }

      final status = await Permission.microphone.request();
      if (kDebugMode) debugPrint('microphone permission status: $status');

      if (!status.isGranted) {
        emit(RecordErrorState("Microphone permission denied"));
        return;
      }

      // now we have permission
      if (_speech == null) await initSpeech();
      if (_speech == null) {
        emit(RecordErrorState("Speech recognizer not available"));
        return;
      }

      isRecording = true;
      hasFinalResult = false;
      currentRecognizedWords = '';
      emit(RecordInProgressState(currentRecognizedWords));

      _startRecordingTimer();
      await _restartListening();
    } catch (e, st) {
      if (kDebugMode) debugPrint('startRecording error: $e\n$st');
      emit(RecordErrorState('Failed to start recording: ${e.toString()}'));
    }
  }

  Future<void> stopRecording() async {
    // be idempotent
    if (_speech == null || !isRecording) return;

    if (kDebugMode) debugPrint('stopRecording: stopping...');
    _isStopping = true;
    try {
      await _speech!.stop();
    } catch (e, st) {
      if (kDebugMode) debugPrint('stopRecording stop() error: $e\n$st');
    }

    isRecording = false;
    _stopRecordingTimer();
    _isListening = false;
    _isStopping = false;

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
      if (kDebugMode) debugPrint('Error incrementing recording count: $e');
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

  // ==================== SESSION MANAGEMENT ====================
  Future<void> completeSession() async {
    try {
      monthlyCompletedSessions = await limitsService.incrementSession(userId);
      emit(SessionCompletedState(monthlyCompletedSessions));
    } catch (e) {
      if (kDebugMode) debugPrint('Error incrementing monthly session count: $e');
    }
  }

  void resetRecordingState() {
    currentRecognizedWords = '';
    finalRecordedText = null;
    hasFinalResult = false;
    currentSoundLevel = 0.0;
    isRecording = false;
    _stopRecordingTimer();
    emit(RecordingStateResetState());
  }

  // ==================== UI STATE MANAGEMENT ====================
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
    if (stage == Stage.generate) {
      resetRecordingState();
    }
    currentStage = stage;
    emit(StageChangedState(stage));
  }

  @override
  Future<void> close() async {
    // tidy up resources safely
    try {
      _stopRecordingTimer();
      if (isRecording) {
        try {
          await _speech?.stop();
        } catch (e) {
          if (kDebugMode) debugPrint('close() stop() error: $e');
        }
      }
    } catch (_) {}

    try {
      await _connectivitySub?.cancel();
    } catch (e) {
      if (kDebugMode) debugPrint('close() connectivity cancel error: $e');
    }
    _connectivitySub = null;

    try {
      _connectivityDebounce?.cancel();
    } catch (_) {}
    _connectivityDebounce = null;

    return super.close();
  }
}
