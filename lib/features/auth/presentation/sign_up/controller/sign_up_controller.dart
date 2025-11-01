import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/common/widgets/app_toast.dart';

import 'sign_up_state.dart';

final signUpControllerProvider =
    NotifierProvider<SignUpController, SignUpState>(SignUpController.new);

class SignUpController extends Notifier<SignUpState> {
  @override
  SignUpState build() => const SignUpState();

  void setRole(SignUpRole r) => state = state.copyWith(role: r, step: 0);

  void setFirstName(String v) => state = state.copyWith(firstName: v);

  void setLastName(String v) => state = state.copyWith(lastName: v);

  void setEmail(String v) => state = state.copyWith(email: v);

  void setDob(DateTime? d) => state = state.copyWith(dob: d);

  void setPhone(String v) => state = state.copyWith(phone: v);

  void setAddress(String v) => state = state.copyWith(address: v);

  void setLevel(String v) => state = state.copyWith(level: v);

  void setGroup(String v) => state = state.copyWith(group: v);

  void setResume(String v) => state = state.copyWith(resumeLink: v);

  void next() => state = state.copyWith(step: (state.step + 1).clamp(0, 3));

  void back() => state = state.copyWith(step: (state.step - 1).clamp(0, 3));

  void setStep(int v) => state = state.copyWith(step: v.clamp(0, 3));

  Future<void> submit(BuildContext context) async {
    if (state.firstName.trim().isEmpty || state.lastName.trim().isEmpty) {
      setStep(0);
      AppToast.showError(context, 'Please enter your full name');
      return;
    }
    if (state.email.trim().isEmpty || state.dob == null) {
      setStep(1);
      AppToast.showError(context, 'Please enter email & date of birth');
      return;
    }
    if (state.phone.trim().isEmpty || state.address.trim().isEmpty) {
      setStep(2);
      AppToast.showError(context, 'Please enter phone & address');
      return;
    }
    if (state.role == SignUpRole.student) {
      if (state.level.isEmpty || state.group.isEmpty) {
        setStep(3);
        AppToast.showError(context, 'Please select level & group');
        return;
      }
    } else if (state.resumeLink.trim().isEmpty) {
      setStep(3);
      AppToast.showError(context, 'Please enter resume link');
      return;
    }

    state = state.copyWith(loading: true);

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: state.email.trim(),
        password: "temp@123456",
      );

      final user = cred.user;
      if (user == null) {
        AppToast.showError(context, "Account creation failed");
        return;
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        "uid": user.uid,
        "role": state.role.name,
        "firstName": state.firstName.trim(),
        "lastName": state.lastName.trim(),
        "email": state.email.trim(),
        "dob": state.dob?.toIso8601String(),
        "phone": state.phone.trim(),
        "address": state.address.trim(),
        if (state.role == SignUpRole.student) ...{
          "level": state.level,
          "group": state.group,
        } else
          "resumeLink": state.resumeLink.trim(),
        "createdAt": DateTime.now().toIso8601String(),
      });

      AppToast.showSuccess(context, "Account created! Verify OTP email");

      if (context.mounted) {
        context.go('/verify-otp', extra: state.email.trim());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        AppToast.showError(context, "Email already exists");
      } else {
        AppToast.showError(context, "Signup failed: ${e.message}");
      }
    } finally {
      state = state.copyWith(loading: false);
    }
  }
}
