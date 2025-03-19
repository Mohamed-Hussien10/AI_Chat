import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSendMessage;
  final VoidCallback scrollToBottom;

  ChatInput({
    required this.onSendMessage,
    required this.scrollToBottom,
    super.key,
  });

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Ask Me anything...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onSubmitted: (_) => _send(),
              onTap: scrollToBottom,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _send,
            mini: true,
            backgroundColor: Colors.teal[600],
            elevation: 2,
            hoverElevation: 4,
            child: const Icon(Icons.send, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _send() {
    onSendMessage(_controller.text);
    _controller.clear();
  }
}
