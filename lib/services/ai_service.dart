import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;

  late final GenerativeModel _model;
  ChatSession? _chatSession;

  AiService._internal() {
    // We expect the API key to be passed via --dart-define=GEMINI_API_KEY
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
    
    // Fallback to a placeholder if not provided, though it won't work without a real key
    final keyToUse = apiKey.isNotEmpty ? apiKey : 'YOUR_API_KEY_HERE';

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: keyToUse,
      systemInstruction: Content.system(
        'You are a helpful, concise AI assistant integrated into the "Unfold" app, '
        'which is a household tips and organization app. Provide clear, practical advice '
        'for home management, cleaning, organization, and DIY. Keep your answers brief '
        'and use markdown formatting where appropriate.',
      ),
    );
  }

  /// Starts a new chat session or returns the existing one
  ChatSession get chatSession {
    _chatSession ??= _model.startChat();
    return _chatSession!;
  }

  /// Sends a message and returns the response text
  Future<String?> sendMessage(String message) async {
    try {
      final response = await chatSession.sendMessage(Content.text(message));
      return response.text;
    } catch (e) {
      // ignore: avoid_print
      print('Error sending message to AI: $e');
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }

  /// Resets the chat history
  void clearChat() {
    _chatSession = _model.startChat();
  }
}
