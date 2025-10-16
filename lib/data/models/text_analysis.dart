class TextAnalysis {
  final List<String> originalWords;
  final List<String> recordedWords;
  final Set<int> matchedIndices;
  final int correctWords;
  final int missedWords;
  final double accuracy;

  TextAnalysis({
    required this.originalWords,
    required this.recordedWords,
    required this.matchedIndices,
    required this.correctWords,
    required this.missedWords,
    required this.accuracy,
  });
}