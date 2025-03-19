import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSendMessage;
  final VoidCallback scrollToBottom;
  final bool isLoading; // Add loading state
  final VoidCallback onCancel; // Add cancel callback

  ChatInput({
    required this.onSendMessage,
    required this.scrollToBottom,
    required this.isLoading,
    required this.onCancel,
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
            onPressed:
                isLoading ? onCancel : _send, // Switch behavior based on state
            mini: true,
            backgroundColor: Colors.teal[600],
            elevation: 2,
            hoverElevation: 4,
            child: Icon(
              isLoading ? Icons.crop_square_rounded : Icons.send, // Switch icon
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _send() {
    if (!isLoading && _controller.text.trim().isNotEmpty) {
      onSendMessage(_controller.text);
      _controller.clear();
    }
  }
}
