import 'dart:convert';
import 'dart:io';
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

    try {
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
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('TIMEOUT');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return GenerateTextResponse.fromJson(data);
      } else if (response.statusCode == 429) {
        // Rate limit exceeded
        throw Exception('RATE_LIMIT');
      } else if (response.statusCode == 403) {
        // API key issue
        throw Exception('API_KEY_ERROR');
      } else if (response.statusCode >= 500) {
        // Server error
        throw Exception('SERVER_ERROR');
      } else {
        throw Exception('API_ERROR: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('NO_INTERNET');
    } on http.ClientException {
      throw Exception('NETWORK_ERROR');
    } catch (e) {
      rethrow;
    }
  }
}