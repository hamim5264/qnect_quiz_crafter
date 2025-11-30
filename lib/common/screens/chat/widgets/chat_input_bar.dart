// import 'package:flutter/material.dart';
// import '../../../../../ui/design_system/tokens/colors.dart';
// import '../../../../../ui/design_system/tokens/typography.dart';
//
// class ChatInputBar extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String> onSend;
//
//   const ChatInputBar({
//     super.key,
//     required this.controller,
//     required this.onSend,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
//       child: Row(
//         children: [
//           Expanded(
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxHeight: 130),
//               child: TextField(
//                 cursorColor: AppColors.secondaryDark,
//                 controller: controller,
//                 keyboardType: TextInputType.multiline,
//                 textInputAction: TextInputAction.newline,
//                 minLines: 1,
//                 maxLines: 6,
//                 enableSuggestions: true,
//                 autocorrect: true,
//                 style: const TextStyle(
//                   fontFamily: AppTypography.family,
//                   color: Colors.white,
//                 ),
//                 decoration: InputDecoration(
//                   hintText: 'Send message or share picture',
//                   hintStyle: const TextStyle(
//                     fontFamily: AppTypography.family,
//                     color: Colors.white54,
//                   ),
//                   filled: true,
//                   fillColor: AppColors.primaryDark.withValues(alpha: 0.3),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 12,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide(color: AppColors.secondaryDark),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: BorderSide(color: AppColors.secondaryDark),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(30),
//                     borderSide: const BorderSide(
//                       color: AppColors.secondaryDark,
//                       width: 1.4,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           GestureDetector(
//             onTap: () => onSend(controller.text),
//             child: Container(
//               padding: const EdgeInsets.all(12),
//               decoration: const BoxDecoration(
//                 color: AppColors.secondaryDark,
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(Icons.send_rounded, color: Colors.black),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../ui/design_system/tokens/typography.dart';

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

  // ==============================================================
  // 🔹 AUDIO DURATION FIX (JUST_AUDIO)
  // ==============================================================
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

  // ==============================================================
  // 🔹 IMAGE PREVIEW + SEND
  // ==============================================================
  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );

      if (result == null) return;

      final name =
          "img_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final bytes = result.files.first.bytes;

      if (bytes == null) return;

      // Show preview dialog before uploading
      await showDialog(
        context: context,
        builder: (_) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        child: Text("Cancel", style: TextStyle(color: Colors.white,),)
                    ),
                  ),
                  // TextButton(
                  //   child: const Text("Cancel", style: TextStyle(color: Colors.red)),
                  //   onPressed: () => Navigator.pop(context),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      child: const Text("Send Image", style: TextStyle(color: Colors.black,),),
                      onPressed: () async {
                        Navigator.pop(context);

                        final ref = FirebaseStorage.instance
                            .ref()
                            .child("chat_images")
                            .child(name);

                        await ref.putData(bytes, SettableMetadata(contentType: "image/jpeg"));
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

  // ==============================================================
  // 🔹 START RECORDING (SAFE PATH)
  // ==============================================================
  Future<void> _startRecording() async {
    try {
      final hasPermission = await _recorder.hasPermission();
      if (!hasPermission) return;

      final dir = await getTemporaryDirectory();
      final file = "${dir.path}/aud_${DateTime.now().millisecondsSinceEpoch}.m4a";

      _currentAudioPath = file;

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
        ),
        path: file,
      );

      if (!mounted) return;
      setState(() => _isRecording = true);
    } catch (e) {
      debugPrint("START RECORD ERROR: $e");
    }
  }

  // ==============================================================
  // 🔹 STOP RECORDING + UPLOAD
  // ==============================================================
  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path == null) return;

      final duration = await _getAudioDuration(path);
      final file = File(path);

      final ref = FirebaseStorage.instance
          .ref()
          .child("chat_audio")
          .child("aud_${DateTime.now().millisecondsSinceEpoch}.m4a");

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      if (!mounted) return;

      widget.onSendAudio?.call(url, duration);

      setState(() => _isRecording = false);
    } catch (e) {
      debugPrint("STOP RECORD ERROR: $e");
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  // ==============================================================
  // 🔹 UI
  // ==============================================================
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.primaryDark,
      child: Row(
        children: [
          // 📸 IMAGE
          IconButton(
            icon: const Icon(Icons.image, color: Colors.white70),
            onPressed: _pickImage,
          ),

          // 🎤 MIC (HOLD TO RECORD)
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

          // ✏ TEXT FIELD
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
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
            ),
          ),

          // ➤ SEND
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
