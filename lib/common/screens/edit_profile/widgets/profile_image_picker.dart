import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../ui/design_system/tokens/colors.dart';

class ProfileImagePicker extends StatefulWidget {
  const ProfileImagePicker({super.key});

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  String? imagePath;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imagePath = picked.path);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            backgroundImage:
                imagePath != null ? FileImage(File(imagePath!)) : null,
            child:
                imagePath == null
                    ? const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 45,
                    )
                    : null,
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
