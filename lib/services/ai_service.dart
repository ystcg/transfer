import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  static final AiService _instance = AiService._internal();
  factory AiService() => _instance;

  late final GenerativeModel _model;
  ChatSession? _chatSession;
  bool _isApiKeyValid = false;

  AiService._internal();

  /// Must be called before using the service to inject the app's local data
  void init(String tipsJsonData) {
    const apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

    // Check if the user passed a real key
    final lowerKey = apiKey.toLowerCase();
    if (apiKey.isEmpty || lowerKey.contains('your_api_key')) {
      _isApiKeyValid = false;
    } else {
      _isApiKeyValid = true;
    }

    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: _isApiKeyValid ? apiKey : 'INVALID_KEY',
      systemInstruction: Content.system(
        'You are a helpful, concise AI assistant integrated into the "Unfold" app, '
        'which is a household tips and organization app. Provide clear, practical advice '
        'for home management, cleaning, organization, and DIY. Keep your answers brief '
        'and use markdown formatting where appropriate.\n\n'
        'CRITICAL KNOWLEDGE: Here is the entire JSON database of all household tips '
        'available in the Unfold app. You MUST use this information to answer user '
        'questions whenever relevant. If the user asks about something covered in '
        'these tips, reference the specific steps provided here.\n\n'
        'APP DATA:\n$tipsJsonData',
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
    if (!_isApiKeyValid) {
      await Future.delayed(const Duration(milliseconds: 500));
      return '### ⚠️ Real API Key Needed\n\n'
          'It looks like you passed the placeholder text instead of a real API key!\n\n'
          'To use the AI Chatbot, you must get your own free API key from [Google AI Studio](https://aistudio.google.com/).\n\n'
          '**Once you have it, run the app like this:**\n'
          '```bash\nflutter run --dart-define=GEMINI_API_KEY="AIzaSyYourRealKeyHere..."\n```';
    }

    try {
      final response = await chatSession.sendMessage(Content.text(message));
      return response.text;
    } catch (e) {
      // ignore: avoid_print
      print('Error sending message to AI: $e');
      return 'Sorry, I encountered an error connecting to the AI. Please try again later.';
    }
  }

  /// Resets the chat history
  void clearChat() {
    _chatSession = _model.startChat();
  }
}
