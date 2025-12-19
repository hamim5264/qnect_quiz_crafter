import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import '../ui/design_system/theme/theme.dart';

class QuizCrafterApp extends ConsumerWidget {
  const QuizCrafterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'QuizCrafter',
      theme: AppTheme.build(),
      routerConfig: router,
    );
  }
}
