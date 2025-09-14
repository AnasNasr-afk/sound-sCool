class GenerateTextRequest {
  final String language;
  final String level;


  GenerateTextRequest({
    required this.language,
    required this.level,
  });

  /// Build the prompt text
  String toPrompt() {
    return """
You are a helpful language tutor. Write a new, unique, and engaging text in $language, 
around 20 words long, for a learner at CEFR level $level.

• Do not repeat any text or sentences you have generated before.  
• Always vary the topic (e.g., daily routine, shopping, hobbies, travel, family, food, school, work).  
• Use only vocabulary and grammar suitable for level $level.  
• Keep sentences clear, simple, and easy to follow.  
• Make it practical, like something the learner might read or hear in everyday life.  
""";
  }


}
