import 'package:flutter/material.dart';

class TypingIndicator extends StatefulWidget {
  final bool isUser;

  const TypingIndicator({required this.isUser});

  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FadeTransition(
          opacity: _animation,
          child: Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: widget.isUser ? Colors.white70 : Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        ),
        FadeTransition(
          opacity: _animation,
          child: Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: widget.isUser ? Colors.white70 : Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        ),
        FadeTransition(
          opacity: _animation,
          child: Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: widget.isUser ? Colors.white70 : Colors.grey[600],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
