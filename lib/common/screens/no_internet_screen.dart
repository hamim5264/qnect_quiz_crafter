import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qnect_quiz_crafter/ui/design_system/tokens/colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 90, color: Colors.white),
            const SizedBox(height: 16),

            const Text(
              'No Internet Connection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Please check your connection and try again.',
              style: TextStyle(color: Colors.white60, fontSize: 14),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryDark,
                foregroundColor: AppColors.textPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              onPressed: () {
                context.go('/');
              },
              child: const Text(
                'Retry',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
