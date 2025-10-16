// lib/data/models/voice_recording_model.dart
class VoiceRecordingModel {
  final String id;
  final String name;
  final String language;
  final String level;
  final String generatedText;
  final String recordedText;
  final double accuracyScore;
  final DateTime createdAt;
  final String audioUrl; // Firebase Storage URL
  final String storagePath; // Path in Firebase Storage

  VoiceRecordingModel({
    required this.id,
    required this.name,
    required this.language,
    required this.level,
    required this.generatedText,
    required this.recordedText,
    required this.accuracyScore,
    required this.createdAt,
    required this.audioUrl,
    required this.storagePath,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'language': language,
      'level': level,
      'generatedText': generatedText,
      'recordedText': recordedText,
      'accuracyScore': accuracyScore,
      'createdAt': createdAt.toIso8601String(),
      'audioUrl': audioUrl,
      'storagePath': storagePath,
    };
  }

  // Create from Firestore Map
  factory VoiceRecordingModel.fromMap(Map<String, dynamic> map, String id) {
    return VoiceRecordingModel(
      id: id,
      name: map['name'] ?? 'Voice Memo',
      language: map['language'] ?? '',
      level: map['level'] ?? '',
      generatedText: map['generatedText'] ?? '',
      recordedText: map['recordedText'] ?? '',
      accuracyScore: (map['accuracyScore'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt']),
      audioUrl: map['audioUrl'] ?? '',
      storagePath: map['storagePath'] ?? '',
    );
  }

  // Create a copy with updated fields
  VoiceRecordingModel copyWith({String? name}) {
    return VoiceRecordingModel(
      id: id,
      name: name ?? this.name,
      language: language,
      level: level,
      generatedText: generatedText,
      recordedText: recordedText,
      accuracyScore: accuracyScore,
      createdAt: createdAt,
      audioUrl: audioUrl,
      storagePath: storagePath,
    );
  }
}