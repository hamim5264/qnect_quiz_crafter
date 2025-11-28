import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widgets/common_curved_background.dart';
import '../../../features/admin/presentation/dashboard/controller/admin_controller.dart';
import '../../../features/guest_and_student/presentation/dashboard/provider/student_provider.dart';
import '../../../features/auth/providers/auth_providers.dart';
import '../../../features/teacher/data/providers/teacher_providers.dart';
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
      } else if (widget.role == "teacher") {
        await ref.read(teacherControllerProvider.notifier).loadTeacher(uid);
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
        addressCtrl.text = state.student!.address ?? "";
        profileImageUrl = state.student!.profileImage;

        final dobString = state.student!.dob ?? "";
        if (dobString.isNotEmpty) {
          try {
            dobValue = DateTime.parse(dobString);
            dobCtrl.text = dobString;
          } catch (_) {}
        }

        resumeCtrl.text = "";
      }
    } else if (widget.role == "teacher") {
      final state = ref.read(teacherControllerProvider);

      if (state.teacher != null) {
        firstNameCtrl.text = state.teacher!.firstName;
        lastNameCtrl.text = state.teacher!.lastName;
        phoneCtrl.text = state.teacher!.phone ?? "";
        addressCtrl.text = state.teacher!.address ?? "";
        resumeCtrl.text = state.teacher!.resumeLink ?? "";
        profileImageUrl = state.teacher!.profileImage;

        final dobString = state.teacher!.dob ?? "";
        if (dobString.isNotEmpty) {
          try {
            dobValue = DateTime.parse(dobString);
            dobCtrl.text = dobString;
          } catch (_) {}
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
    final teacherState =
        widget.role == "teacher" ? ref.watch(teacherControllerProvider) : null;

    final isLoading =
        widget.role == "admin"
            ? adminState?.loading ?? false
            : widget.role == "student"
            ? studentState?.loading ?? false
            : teacherState?.loading ?? false;

    final isSaving =
        widget.role == "admin"
            ? adminState?.buttonLoading ?? false
            : widget.role == "student"
            ? studentState?.buttonLoading ?? false
            : teacherState?.buttonLoading ?? false;

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
                            : teacherState?.teacher?.email,
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
                      } else if (widget.role == "teacher") {
                        ref
                            .read(teacherControllerProvider.notifier)
                            .updateTeacherImage(uid, file);
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

                      if (widget.role == "teacher") {
                        await ref
                            .read(teacherControllerProvider.notifier)
                            .updateTeacherProfile(
                              uid: uid,
                              firstName: firstNameCtrl.text.trim(),
                              lastName: lastNameCtrl.text.trim(),
                              phone: phoneCtrl.text.trim(),
                              dob: dobValue.toIso8601String(),
                              address: addressCtrl.text.trim(),
                              resumeLink: resumeCtrl.text.trim(),
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
