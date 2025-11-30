import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../ui/design_system/tokens/colors.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String text) onSend;
  final Function(String url)? onSendImage;
  final Function(String url, int duration)? onSendAudio;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.onSendImage,
    this.onSendAudio,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _currentAudioPath;
  int _duration = 0;

  void _startTimer() {
    Future.doWhile(() async {
      if (!_isRecording) return false;

      await Future.delayed(const Duration(seconds: 1));
      if (!_isRecording) return false;

      setState(() => _duration++);
      return true;
    });
  }

  Future<int> _getAudioDuration(String path) async {
    try {
      final player = AudioPlayer();
      await player.setFilePath(path);
      final duration = player.duration?.inSeconds ?? 1;
      await player.dispose();
      return duration;
    } catch (_) {
      return 1;
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final name = "img_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final bytes = result.files.first.bytes;

      if (bytes == null) return;

      await showDialog(
        context: context,
        builder:
            (_) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.memory(bytes, fit: BoxFit.cover),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Send Image",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);

                            final ref = FirebaseStorage.instance
                                .ref()
                                .child("chat_images")
                                .child(name);

                            await ref.putData(
                              bytes,
                              SettableMetadata(contentType: "image/jpeg"),
                            );
                            final url = await ref.getDownloadURL();

                            widget.onSendImage?.call(url);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
      );
    } catch (e) {
      debugPrint("IMAGE ERROR: $e");
    }
  }

  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) return;

      final dir = await getTemporaryDirectory();
      final filePath =
          "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a";

      await _recorder.start(const RecordConfig(), path: filePath);

      setState(() {
        _isRecording = true;
        _duration = 0;
      });

      // 🔥 Start timer to count seconds
      _startTimer();
    } catch (e) {
      debugPrint("REC START ERROR: $e");
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();

      setState(() => _isRecording = false);

      if (path == null) return;

      final file = File(path);

      final ref = FirebaseStorage.instance
          .ref()
          .child("chat_audio")
          .child("aud_${DateTime.now().millisecondsSinceEpoch}.m4a");

      await ref.putFile(file, SettableMetadata(contentType: "audio/mp4a-latm"));

      final url = await ref.getDownloadURL();

      widget.onSendAudio?.call(url, _duration);
    } catch (e) {
      debugPrint("REC STOP / UPLOAD ERROR: $e");
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.primaryDark,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white70),
            onPressed: _pickImage,
          ),

          GestureDetector(
            onLongPress: _startRecording,
            onLongPressEnd: (_) => _stopRecording(),
            child: Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              color: _isRecording ? Colors.redAccent : Colors.white70,
              size: 26,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: widget.controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: false,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 1.4,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 1.4,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 1.8,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
            ),
          ),

          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              final text = widget.controller.text.trim();
              if (text.isNotEmpty) widget.onSend(text);
            },
          ),
        ],
      ),
    );
  }
}
