import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAPIService {
  static const String _apiKey =
      "AIzaSyBeT-9koSPduFzyDa22NIFjmlaX4UDgLgc"; // Replace with your actual API key
  static const String _baseUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

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
      return "Error: ${response.statusCode} - ${response.body}";
    }
  }
}
