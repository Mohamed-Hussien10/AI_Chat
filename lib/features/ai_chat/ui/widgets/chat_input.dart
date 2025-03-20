import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;
  final Function(Uint8List, String, String)
  onFileUpload; // Updated to include prompt
  final VoidCallback scrollToBottom;
  final bool isLoading;
  final VoidCallback onCancel;

  const ChatInput({
    required this.onSendMessage,
    required this.onFileUpload,
    required this.scrollToBottom,
    required this.isLoading,
    required this.onCancel,
    super.key,
  });

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final TextEditingController _controller = TextEditingController();
  Uint8List? _pendingFileBytes;
  String? _pendingFileName;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    if (!widget.isLoading && _controller.text.trim().isNotEmpty) {
      if (_pendingFileBytes != null && _pendingFileName != null) {
        widget.onFileUpload(
          _pendingFileBytes!,
          _pendingFileName!,
          _controller.text,
        );
        _pendingFileBytes = null;
        _pendingFileName = null;
      } else {
        widget.onSendMessage(_controller.text);
      }
      _controller.clear();
      setState(() {}); // Clear file preview
    }
  }

  Future<void> _pickAndUploadFile() async {
    if (widget.isLoading) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'pdf'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        PlatformFile file = result.files.first;
        if (file.bytes != null) {
          setState(() {
            _pendingFileBytes = file.bytes!;
            _pendingFileName = file.name;
          });
          widget.scrollToBottom();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: File data not available')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
    }
  }

  Widget _buildFilePreview() {
    if (_pendingFileBytes == null || _pendingFileName == null)
      return const SizedBox.shrink();

    final isPdf = _pendingFileName!.toLowerCase().endsWith('.pdf');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal[600]!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPdf ? Icons.picture_as_pdf : Icons.image,
            color: Colors.teal[600],
            size: 24,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              _pendingFileName!,
              style: TextStyle(
                color: Colors.teal[800],
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: Colors.grey[600]),
            onPressed: () {
              setState(() {
                _pendingFileBytes = null;
                _pendingFileName = null;
              });
            },
            tooltip: 'Remove file',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_pendingFileName != null) _buildFilePreview(),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file, color: Colors.teal[600]),
                onPressed: _pickAndUploadFile,
                tooltip: 'Upload Image or PDF',
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText:
                        _pendingFileName != null
                            ? "Enter a prompt for $_pendingFileName..."
                            : "Ask Me anything or upload a file...",
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
                  onTap: widget.scrollToBottom,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton(
                onPressed: widget.isLoading ? widget.onCancel : _send,
                mini: true,
                backgroundColor: Colors.teal[600],
                elevation: 2,
                hoverElevation: 4,
                child: Icon(
                  widget.isLoading ? Icons.crop_square_rounded : Icons.send,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
