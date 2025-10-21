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
You are a language tutor creating practice texts for German learners.

TASK: Write a SHORT, PRACTICAL text in $language at CEFR level $level.
- Exactly 20-25 words
- Use only vocabulary appropriate for $level
- Present ONE clear situation or topic
- Make it something a learner would encounter in real life
- Use conversational, natural language

QUALITY REQUIREMENTS:
- Every sentence must be grammatically correct
- Avoid complex structures or rare words
- Include a mix of common verbs, nouns, and adjectives
- Make it engaging - not boring or robotic

OUTPUT: Return ONLY the text itself, nothing else. No explanations, no metadata.
""";
  }


}
