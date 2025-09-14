import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../../data/models/generate_text_request.dart';
import '../../data/networking/api_service.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  final ApiService apiService;
  HomeCubit(this.apiService) : super(HomeInitialState()) {
    _audioRecorder = AudioRecorder();
    _speechToText = SpeechToText();
  }

  static HomeCubit get(context) => BlocProvider.of(context);

  // App State
  String? displayedText;
  String selectedLanguage = "German";
  String selectedLevel = "A2";
  String? expandedSection;

  // Audio Recording
  AudioRecorder? _audioRecorder;
  bool isRecording = false;
  String? recordedAudioPath;

  // Speech Recognition - Simple variables
  SpeechToText? _speechToText;
  String spokenText = '';  // What user has spoken so far
  String currentWord = ''; // Current word being spoken
  List<String> spokenWords = []; // All words spoken so far

  // Timer for recording
  Timer? _recordingTimer;
  int _elapsedSeconds = 0;
  final int _maxRecordingSeconds = 30;

  String get formattedRecordingTime {
    final minutes = (_elapsedSeconds ~/ 60).toString().padLeft(1, '0');
    final seconds = (_elapsedSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds / 0:$_maxRecordingSeconds";
  }

  void _startRecordingTimer() {
    _elapsedSeconds = 0;
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _elapsedSeconds++;
      emit(SpeechTimerTickState(formattedRecordingTime));

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

  /// Generate practice text using Gemini API
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

  // UI State Management
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

  // Simple speech recognition setup
  Future<bool> _initSpeech() async {
    return await _speechToText!.initialize();
  }

  // Handle speech results - keep it simple
  void _onSpeechResult(result) {
    spokenText = result.recognizedWords.toLowerCase();

    // Get individual words
    spokenWords = spokenText.split(' ').where((w) => w.isNotEmpty).toList();

    // Get current word (last word)
    if (spokenWords.isNotEmpty) {
      currentWord = spokenWords.last;
    }

    // Emit state to update UI
    emit(SpeechPartialResultState(currentWord));
  }

  // Start recording with simple speech recognition
  Future<void> startRecording() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        emit(SpeechErrorState('Microphone permission required'));
        return;
      }

      if (!await _audioRecorder!.hasPermission()) {
        emit(SpeechErrorState('Recording permission not available'));
        return;
      }

      // Init speech
      bool speechAvailable = await _initSpeech();
      if (!speechAvailable) {
        emit(SpeechErrorState('Speech recognition not available'));
        return;
      }

      // Start recording file
      final appDocDir = await getApplicationDocumentsDirectory();
      final filePath = '${appDocDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';

      await _audioRecorder!.start(
        const RecordConfig(encoder: AudioEncoder.wav),
        path: filePath,
      );

      // Start speech listening
      await _speechToText!.listen(
        onResult: _onSpeechResult,
        partialResults: true,
        listenFor: Duration(seconds: _maxRecordingSeconds),
        pauseFor: const Duration(seconds: 2),
      );

      // Reset variables
      isRecording = true;
      recordedAudioPath = filePath;
      spokenText = '';
      currentWord = '';
      spokenWords = [];

      _startRecordingTimer();
      emit(SpeechListeningState());

    } catch (e) {
      isRecording = false;
      emit(SpeechErrorState('Failed to start recording'));
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    try {
      // Stop speech recognition
      await _speechToText!.stop();

      // Stop recording
      final path = await _audioRecorder!.stop();

      isRecording = false;
      _stopRecordingTimer();

      if (path != null) {
        recordedAudioPath = path;

        // Show completion briefly
        emit(SpeechStoppedState());

        // Analyze results after a short delay
        await Future.delayed(const Duration(seconds: 1));
        _analyzeResults();
      } else {
        emit(SpeechErrorState('Recording failed'));
      }

    } catch (e) {
      isRecording = false;
      _stopRecordingTimer();
      emit(SpeechErrorState('Failed to stop recording'));
    }
  }

  // Simple analysis - compare target words with spoken words
  void _analyzeResults() {
    if (displayedText == null) {
      emit(SpeechErrorState('No text to compare'));
      return;
    }

    emit(PronunciationAnalysisLoadingState());

    // Get target words (clean)
    final targetWords = displayedText!
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s]'), '')
        .split(' ')
        .where((w) => w.isNotEmpty)
        .toList();

    // Simple word comparison
    List<bool> results = [];
    int correctCount = 0;

    for (int i = 0; i < targetWords.length; i++) {
      bool isCorrect = false;

      if (i < spokenWords.length) {
        // Simple matching - you can enhance this
        isCorrect = targetWords[i] == spokenWords[i] ||
            _similarWords(targetWords[i], spokenWords[i]);
      }

      results.add(isCorrect);
      if (isCorrect) correctCount++;
    }

    double accuracy = targetWords.isNotEmpty ? correctCount / targetWords.length : 0.0;

    // Emit results
    Future.delayed(const Duration(seconds: 1), () {
      emit(PronunciationResultState(
        recognizedText: spokenText,
        wordAnalysis: results,
        accuracy: accuracy,
        wordResults: Map.fromIterable(
          List.generate(results.length, (i) => i),
          value: (i) => results[i],
        ),
      ));
    });
  }

  // Simple word similarity check
  bool _similarWords(String word1, String word2) {
    if (word1.length != word2.length) return false;

    int matches = 0;
    for (int i = 0; i < word1.length; i++) {
      if (word1[i] == word2[i]) matches++;
    }

    return matches / word1.length >= 0.8; // 80% similarity
  }

  void cancelRecording() async {
    if (!isRecording) return;

    try {
      await _speechToText!.stop();
      await _audioRecorder!.stop();

      isRecording = false;
      _stopRecordingTimer();

      if (recordedAudioPath != null) {
        final file = File(recordedAudioPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }

      recordedAudioPath = null;
      spokenText = '';
      currentWord = '';
      spokenWords = [];

      emit(SpeechCancelledState());

    } catch (e) {
      isRecording = false;
      _stopRecordingTimer();
      emit(SpeechErrorState('Failed to cancel recording'));
    }
  }

  void retryPronunciation() {
    recordedAudioPath = null;
    spokenText = '';
    currentWord = '';
    spokenWords = [];
    emit(GenerateTextSuccessState(displayedText!));
  }

  void startNewSession() {
    displayedText = null;
    recordedAudioPath = null;
    spokenText = '';
    currentWord = '';
    spokenWords = [];
    emit(HomeInitialState());
  }

  @override
  Future<void> close() async {
    _stopRecordingTimer();
    if (isRecording) {
      await _speechToText?.stop();
      await _audioRecorder?.stop();
    }
    _audioRecorder?.dispose();
    return super.close();
  }
}