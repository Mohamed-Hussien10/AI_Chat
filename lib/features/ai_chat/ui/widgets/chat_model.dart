import 'dart:typed_data';

class ChatMessage {
  final String role;
  final String text;
  final bool isTyping;
  final DateTime timestamp;
  final Uint8List? fileBytes; // Add file bytes
  final String? fileName; // Add file name

  ChatMessage({
    required this.role,
    required this.text,
    this.isTyping = false,
    required this.timestamp,
    this.fileBytes,
    this.fileName,
  });

  factory ChatMessage.user(
    String text, {
    Uint8List? fileBytes,
    String? fileName,
  }) {
    return ChatMessage(
      role: "user",
      text: text,
      timestamp: DateTime.now(),
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  factory ChatMessage.ai(
    String text, {
    bool isTyping = false,
    Uint8List? fileBytes,
    String? fileName,
  }) {
    return ChatMessage(
      role: "ai",
      text: text,
      isTyping: isTyping,
      timestamp: DateTime.now(),
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  bool get isUser => role == "user";

  ChatMessage copyWith({String? text, bool? isTyping}) {
    return ChatMessage(
      role: role,
      text: text ?? this.text,
      isTyping: isTyping ?? this.isTyping,
      timestamp: timestamp,
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }
}
