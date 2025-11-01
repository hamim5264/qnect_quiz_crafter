import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GuestHomeScreen extends ConsumerWidget {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Guest Dashboard"),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome Guest 👤",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  context.go('/sign-in');
                },
                child: const Text("Login / Sign Up"),
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  context.go('/onboarding');
                },
                child: const Text("Back to Onboarding"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
