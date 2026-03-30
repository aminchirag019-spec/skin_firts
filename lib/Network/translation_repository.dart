import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static Future<String> translate(String text, String targetLanguage) async {
    if (text.isEmpty) return text;

    print("🌐 Translating: '$text' to '$targetLanguage'");

    try {
      final url = Uri.parse(
        'https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=$targetLanguage&dt=t&q=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        if (data.isNotEmpty && data[0] != null) {
          StringBuffer translatedBuffer = StringBuffer();
          for (var segment in data[0]) {
            if (segment is List && segment.isNotEmpty) {
              translatedBuffer.write(segment[0]);
            }
          }
          String result = translatedBuffer.toString();
          print("✅ Success: $result");
          return result.isNotEmpty ? result : text;
        }
      } else {
        print("❌ Translation Error: Status Code ${response.statusCode}, Body: ${response.body}");
      }
      return text;
    } catch (e) {
      print("⚠️ Translation Exception: $e");
      return text;
    }
  }
}
