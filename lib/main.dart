import 'package:chat_gpt_screen/features/ai_chat/ui/chat_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AIChatApp());
}

class AIChatApp extends StatelessWidget {
  const AIChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: Colors.grey[50],
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', color: Colors.black87),
        ),
      ),
      home: ChatScreen(),
    );
  }
}
