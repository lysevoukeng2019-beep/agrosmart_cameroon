import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // Remplacez par votre clé Gemini
  final String apiKey = "VOTRE_CLE_GEMINI_ICI";

  Future<String> getAdvice(String message) async {
    try {
      final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
      final content = [Content.text(message)];
      final response = await model.generateContent(content);
      return response.text ?? "Aucune réponse de l'IA.";
    } catch (e) {
      return "Erreur IA : $e";
    }
  }
}
