import 'package:chat_gpt_screen/features/ai_chat/ui/widgets/chat_input.dart';
import 'package:chat_gpt_screen/features/ai_chat/ui/widgets/chat_model.dart';
import 'package:chat_gpt_screen/features/ai_chat/ui/widgets/message_bubble.dart';
import 'package:chat_gpt_screen/features/ai_chat/ui/widgets/modern_loading_indicator.dart';
import 'package:chat_gpt_screen/features/ai_chat/data/gemini_services.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateScrollButtonVisibility);
  }

  void _updateScrollButtonVisibility() {
    if (!_scrollController.hasClients) return;

    final bool shouldShow = !_shouldAutoScroll() && _messages.isNotEmpty;
    if (shouldShow != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = shouldShow;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: _buildChatArea()),
                ChatInput(
                  onSendMessage: _sendMessage,
                  scrollToBottom: _scrollToBottom,
                ),
              ],
            ),
            if (_showScrollToBottom)
              Positioned(
                right: 16,
                bottom: 80,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.teal[600]?.withOpacity(0.9),
                  onPressed: () {
                    _scrollToBottom();
                  },
                  tooltip: 'Scroll to bottom',
                  child: const Icon(Icons.arrow_downward, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text(
        "Chat with AI",
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_sweep, color: Colors.white),
          tooltip: "Clear Chat",
          onPressed: _clearChat,
        ),
      ],
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[700]!, Colors.teal[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
      elevation: 0,
    );
  }

  Widget _buildChatArea() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child:
          _messages.isEmpty && !_isLoading
              ? _buildEmptyState()
              : _buildMessageList(),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      color: Colors.grey[50],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 40, color: Colors.grey[400]),
            const SizedBox(height: 10),
            Text(
              "Start chatting with AI!",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ..._messages.asMap().entries.map(
              (entry) => MessageBubble(
                message: entry.value,
                index: entry.key,
                onDelete: _deleteMessage,
              ),
            ),
            if (_isLoading)
              Align(
                alignment: Alignment.centerLeft,
                child: ModernLoadingIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage.user(message));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      String aiResponse = await GeminiAPIService.getChatResponse(message);
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage.ai("", isTyping: true));
      });
      _typeMessage(aiResponse);
    } catch (e) {
      setState(() {
        _isLoading = false;
        _messages.add(ChatMessage.ai("Oops! Something went wrong. Try again."));
      });
      _scrollToBottom();
    }
  }

  void _typeMessage(String fullResponse) async {
    int lastIndex = _messages.length - 1;
    List<String> lines = fullResponse.split('\n');
    String currentText = "";

    for (String line in lines) {
      String targetText = lines.sublist(0, lines.indexOf(line) + 1).join('\n');
      for (int i = 0; i < line.length; i++) {
        await Future.delayed(const Duration(milliseconds: 1));
        if (mounted) {
          setState(() {
            currentText = targetText.substring(
              0,
              targetText.length - (line.length - i) + 1,
            );
            _messages[lastIndex] = _messages[lastIndex].copyWith(
              text: currentText,
            );
          });
          if (_shouldAutoScroll()) _scrollToBottom();
        }
      }
      if (line != lines.last && mounted) {
        currentText = '$targetText\n';
        setState(() {
          _messages[lastIndex] = _messages[lastIndex].copyWith(
            text: currentText,
          );
        });
      }
    }

    if (mounted) {
      setState(() {
        _messages[lastIndex] = _messages[lastIndex].copyWith(
          text: fullResponse,
          isTyping: false,
        );
      });
      if (_shouldAutoScroll()) _scrollToBottom();
    }
  }

  bool _shouldAutoScroll() {
    if (!_scrollController.hasClients) return false;
    final position = _scrollController.position;
    return position.pixels >= position.maxScrollExtent - 50;
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _deleteMessage(int index) {
    setState(() {
      _messages.removeAt(index);
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollButtonVisibility);
    _scrollController.dispose();
    super.dispose();
  }
}
