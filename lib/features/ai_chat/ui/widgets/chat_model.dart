class ChatMessage {
  final String role;
  final String text;
  final bool isTyping;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.text,
    this.isTyping = false,
    required this.timestamp,
  });

  factory ChatMessage.user(String text) {
    return ChatMessage(role: "user", text: text, timestamp: DateTime.now());
  }

  factory ChatMessage.ai(String text, {bool isTyping = false}) {
    return ChatMessage(
      role: "ai",
      text: text,
      isTyping: isTyping,
      timestamp: DateTime.now(),
    );
  }

  bool get isUser => role == "user";

  ChatMessage copyWith({String? text, bool? isTyping}) {
    return ChatMessage(
      role: role,
      text: text ?? this.text,
      isTyping: isTyping ?? this.isTyping,
      timestamp: timestamp,
    );
  }
}
