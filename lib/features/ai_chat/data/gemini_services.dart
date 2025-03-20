import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiAPIService {
  static String get _apiKey =>
      dotenv.env['CHAT_WITH_AI_API_KET'] ?? 'default_key_if_not_found';
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent";

  static Future<String> getChatResponse(String message) async {
    final Uri url = Uri.parse("$_baseUrl?key=$_apiKey");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": message},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var candidates = jsonResponse['candidates'];

      if (candidates != null && candidates.isNotEmpty) {
        return candidates[0]['content']['parts'][0]['text'];
      } else {
        return "No response from AI.";
      }
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  static Future<String> processFile(
    Uint8List fileBytes,
    String fileName,
    String prompt,
  ) async {
    final Uri url = Uri.parse("$_baseUrl?key=$_apiKey");

    String mimeType = _getMimeType(fileName);
    if (!mimeType.startsWith('image/') && mimeType != 'application/pdf') {
      return "Error: Only image and PDF files are supported by this API.";
    }

    String base64Data = base64Encode(fileBytes);

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {
                "inlineData": {"mimeType": mimeType, "data": base64Data},
              },
              {"text": prompt},
            ],
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var candidates = jsonResponse['candidates'];

      if (candidates != null && candidates.isNotEmpty) {
        return candidates[0]['content']['parts'][0]['text'];
      } else {
        return "No response from AI for file analysis.";
      }
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  static String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'bmp':
        return 'image/bmp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }
}
