import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/generate_text_request.dart';
import '../models/generate_text_response.dart';


class ApiService {
  final String _baseUrl = "https://generativelanguage.googleapis.com/v1beta/models";
  static final String _apiKey = dotenv.env['GEMINI_API_KEY']!;

  Future<GenerateTextResponse> generateText(GenerateTextRequest request) async {
    const model = "gemini-2.0-flash";
    final url = Uri.parse("$_baseUrl/$model:generateContent?key=$_apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": request.toPrompt()}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return GenerateTextResponse.fromJson(data);
    } else {
      throw Exception("Failed to generate text: ${response.body}");
    }
  }
}
