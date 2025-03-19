import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'chat_model.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final int index;
  final Function(int) onDelete;

  const MessageBubble({
    required this.message,
    required this.index,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(index.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(index),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.redAccent,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal[50],
                child: Icon(Icons.smart_toy, size: 20, color: Colors.teal[700]),
              ),
              const SizedBox(width: 10),
            ],
            Flexible(child: _buildMessageContainer(context)),
            if (message.isUser) ...[
              const SizedBox(width: 10),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.teal[50],
                child: Icon(Icons.person, size: 20, color: Colors.teal[700]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContainer(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      decoration: BoxDecoration(
        gradient: message.isUser
            ? LinearGradient(
                colors: [Colors.teal[600]!, Colors.teal[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: message.isUser ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: !message.isUser ? Border.all(color: Colors.grey[200]!, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MarkdownBody(
            data: message.text,
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 16,
                fontFamily: 'Roboto',
                height: 1.4,
              ),
              strong: const TextStyle(fontWeight: FontWeight.bold),
              em: const TextStyle(fontStyle: FontStyle.italic),
              code: TextStyle(backgroundColor: Colors.grey[200], color: Colors.black87, fontFamily: 'monospace'),
            ),
            selectable: true,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: message.isUser ? Colors.white70 : Colors.grey[500],
                  fontSize: 12,
                  fontFamily: 'Roboto',
                ),
              ),
              if (message.isTyping) TypingIndicator(isUser: message.isUser),
            ],
          ),
        ],
      ),
    );
  }
}