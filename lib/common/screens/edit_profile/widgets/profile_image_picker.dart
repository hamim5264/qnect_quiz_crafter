import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../ui/design_system/tokens/colors.dart';
import '../../../../common/widgets/app_skeleton.dart';

class ProfileImagePicker extends StatefulWidget {
  final String? imageUrl;
  final bool isLoading;
  final Function(File?) onImageSelected;

  const ProfileImagePicker({
    super.key,
    required this.imageUrl,
    required this.isLoading,
    required this.onImageSelected,
  });

  @override
  State<ProfileImagePicker> createState() => _ProfileImagePickerState();
}

class _ProfileImagePickerState extends State<ProfileImagePicker> {
  File? pickedImage;

  Future<void> pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (img != null) {
      setState(() => pickedImage = File(img.path));
      widget.onImageSelected(File(img.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const CircleAvatar(
        radius: 48,
        child: AppSkeleton(width: 96, height: 96),
      );
    }

    return GestureDetector(
      onTap: pickImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            backgroundImage:
                pickedImage != null
                    ? FileImage(pickedImage!)
                    : (widget.imageUrl != null && widget.imageUrl!.isNotEmpty)
                    ? NetworkImage(widget.imageUrl!)
                    : null,
            child:
                (pickedImage == null &&
                        (widget.imageUrl == null || widget.imageUrl!.isEmpty))
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
