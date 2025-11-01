import 'package:flutter/material.dart';
import '../../../../../common/widgets/app_loader.dart';
import '../../../../../ui/design_system/tokens/colors.dart';
import '../../../../../ui/design_system/tokens/typography.dart';

class SetPasswordTopImage extends StatelessWidget {
  const SetPasswordTopImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Image.asset(
        "assets/images/auth/set_password.png",
        fit: BoxFit.contain,
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final bool obscure;
  final VoidCallback toggleObscure;

  const PasswordField({
    super.key,
    required this.label,
    required this.onChanged,
    required this.obscure,
    required this.toggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: AppColors.secondaryDark,
      obscureText: obscure,
      onChanged: onChanged,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: AppTypography.family,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: AppColors.primaryDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.secondaryDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.secondaryDark),
        ),
        suffixIcon: IconButton(
          onPressed: toggleObscure,
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
            color: AppColors.secondaryDark,
          ),
        ),
      ),
    );
  }
}

class PasswordStrengthIndicator extends StatelessWidget {
  final double strength; // 0 - 1.0

  const PasswordStrengthIndicator({super.key, required this.strength});

  Color _strengthColor() {
    if (strength < .33) return Colors.redAccent;
    if (strength < .66) return Colors.amber;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        double cutoff = (index + 1) / 4;
        return Expanded(
          child: Container(
            height: 5,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: strength >= cutoff ? _strengthColor() : Colors.white24,
            ),
          ),
        );
      }),
    );
  }
}

class SetPasswordButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const SetPasswordButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: loading,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondaryDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          minimumSize: const Size(double.infinity, 48),
        ),
        child:
            loading
                ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: AppLoader(size: 26, color: Colors.white),
                )
                : const Text(
                  "Set Password",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                    fontFamily: AppTypography.family,
                  ),
                ),
      ),
    );
  }
}
