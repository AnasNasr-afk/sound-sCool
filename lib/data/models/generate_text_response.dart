class GenerateTextResponse {
  final String text;

  GenerateTextResponse({required this.text});

  factory GenerateTextResponse.fromJson(Map<String, dynamic> json) {
    return GenerateTextResponse(
      text: json["candidates"][0]["content"]["parts"][0]["text"] as String,
    );
  }
}
