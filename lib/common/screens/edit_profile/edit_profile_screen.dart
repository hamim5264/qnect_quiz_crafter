import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_curved_background.dart';
import '../../../features/admin/presentation/dashboard/controller/admin_controller.dart';
import '../../../features/guest_and_student/presentation/dashboard/provider/student_provider.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../ui/design_system/tokens/colors.dart';

import 'widgets/profile_header_section.dart';
import 'widgets/profile_form_section.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String role;

  const EditProfileScreen({super.key, required this.role});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final dobCtrl = TextEditingController();
  final resumeCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  DateTime dobValue = DateTime.now();

  String? profileImageUrl;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final uid = ref.read(firebaseAuthProvider).currentUser!.uid;

      if (widget.role == "admin") {
        await ref.read(adminControllerProvider.notifier).loadAdmin(uid);
      } else if (widget.role == "student") {
        await ref.read(studentControllerProvider.notifier).loadStudent(uid);
      }

      _fillControllers();
    });
  }

  void _fillControllers() {
    if (widget.role == "admin") {
      final state = ref.read(adminControllerProvider);

      if (state.admin != null) {
        firstNameCtrl.text = state.admin!.firstName;
        lastNameCtrl.text = state.admin!.lastName;

        phoneCtrl.text = "";
        dobCtrl.text = "";
        resumeCtrl.text = "";
        addressCtrl.text = "";

        profileImageUrl = state.admin!.profileImage;
      }
    } else if (widget.role == "student") {
      final state = ref.read(studentControllerProvider);

      if (state.student != null) {
        firstNameCtrl.text = state.student!.firstName;
        lastNameCtrl.text = state.student!.lastName;
        phoneCtrl.text = state.student!.phone ?? "";
        resumeCtrl.text = "";
        addressCtrl.text = state.student!.address ?? "";
        profileImageUrl = state.student!.profileImage;

        final dobString = state.student!.dob ?? "";
        if (dobString.isNotEmpty) {
          try {
            dobValue = DateTime.parse(dobString);
            dobCtrl.text = dobString;
          } catch (_) {
            dobValue = DateTime.now();
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.read(firebaseAuthProvider).currentUser!.uid;

    final adminState =
        widget.role == "admin" ? ref.watch(adminControllerProvider) : null;

    final studentState =
        widget.role == "student" ? ref.watch(studentControllerProvider) : null;

    final isLoading =
        widget.role == "admin"
            ? adminState?.loading ?? false
            : studentState?.loading ?? false;

    final isSaving =
        widget.role == "admin"
            ? adminState?.buttonLoading ?? false
            : studentState?.buttonLoading ?? false;

    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const CommonCurvedBackground(),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white30),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Barlow",
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),

                  const SizedBox(height: 24),

                  ProfileHeaderSection(
                    role: widget.role,
                    name: firstNameCtrl.text,
                    email:
                        widget.role == "admin"
                            ? adminState?.admin?.email
                            : widget.role == "student"
                            ? studentState?.student?.email
                            : null,
                    profileImage: profileImageUrl,
                    isLoading: isLoading,
                    onImageSelected: (file) {
                      if (file == null) return;
                      if (widget.role == "admin") {
                        ref
                            .read(adminControllerProvider.notifier)
                            .updateImage(uid, file);
                      } else if (widget.role == "student") {
                        ref
                            .read(studentControllerProvider.notifier)
                            .updateImage(uid, file);
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  ProfileFormSection(
                    role: widget.role,

                    firstName: firstNameCtrl.text,
                    lastName: lastNameCtrl.text,
                    phone: phoneCtrl.text,
                    resumeLink: resumeCtrl.text,
                    address: addressCtrl.text,

                    dob: dobValue,

                    onDobChanged: (newDate) {
                      dobValue = newDate;
                      dobCtrl.text = newDate.toIso8601String();
                      setState(() {});
                    },

                    firstNameCtrl: firstNameCtrl,
                    lastNameCtrl: lastNameCtrl,
                    phoneCtrl: phoneCtrl,
                    dobCtrl: dobCtrl,
                    resumeCtrl: resumeCtrl,
                    addressCtrl: addressCtrl,

                    isLoading: isLoading,
                    isSaving: isSaving,

                    onSave: () async {
                      if (widget.role == "admin") {
                        await ref
                            .read(adminControllerProvider.notifier)
                            .updateName(
                              uid,
                              firstNameCtrl.text.trim(),
                              lastNameCtrl.text.trim(),
                            );
                      }

                      if (widget.role == "student") {
                        await ref
                            .read(studentControllerProvider.notifier)
                            .updateStudentProfile(
                              uid: uid,
                              firstName: firstNameCtrl.text.trim(),
                              lastName: lastNameCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              dob: dobValue.toIso8601String(),
                              address: addressCtrl.text.trim(),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
